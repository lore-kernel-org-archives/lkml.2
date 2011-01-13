Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab1AMPDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 10:03:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756885Ab1AMPD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 10:03:29 -0500
Message-ID: <4D2F1430.50906@redhat.com>
Date: Thu, 13 Jan 2011 16:03:12 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Thunderbird/3.1.7
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Tejun Heo <tj@kernel.org>, Karel Zak <kzak@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824 bd_link_disk_holder+0x92/0x1ac()
References: <16069.1294853673@localhost> <4D2E4611.90002@redhat.com> <4D2E6129.8000700@ce.jp.nec.com> <20110113110640.GC30719@htj.dyndns.org> <4D2EE156.1050006@redhat.com> <20110113122701.GG16523@nb.net.home> <20110113131216.GF30719@htj.dyndns.org> <20110113132637.GH16523@nb.net.home> <20110113133722.GG30719@htj.dyndns.org> <4D2F04FF.1070309@redhat.com> <20110113141107.GI30719@htj.dyndns.org> <4D2F0B6A.6010201@redhat.com> <AANLkTinJ68D6Yc-U-Q=ZfS9mqozj5qtHPtySZHOgjcgP@mail.gmail.com> <AANLkTi=LKYzrNsU7jc1Nr4W4CaQ_dmBGeQAquSCp_yAX@mail.gmail.com>
In-Reply-To: <AANLkTi=LKYzrNsU7jc1Nr4W4CaQ_dmBGeQAquSCp_yAX@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2011 03:43 PM, Kay Sievers wrote:

>> On Thu, Jan 13, 2011 at 3:25 PM, Milan Broz <mbroz@redhat.com> wrote:
>>> Maybe, but this was not invented in DM/MD camp:-)
>>> Probably Kay or Greg can answer why it was done this way?
> 
> It's not from Greg or Kay. It just appeared some day in the context of dm. :)

ah, then sorry, I am just confused:-)
But DM does not need it for operation at all so it must had some other reason.
(We have dmsetup ls --tree using dm-ioctls for years.)

> And yes, symlinks *look* nice and simple for the outside, but they are
> not, and have all sorts of problems like non-atomic updates, make it
> impossible to ever rename a device (as long as they copy the device
> name), and and and .... we should not add more of this.

Yes, I agree, if there is better way, let's switch to that.

Milan
