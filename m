Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab1AMN6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 08:58:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756768Ab1AMN6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 08:58:37 -0500
Message-ID: <4D2F04FF.1070309@redhat.com>
Date: Thu, 13 Jan 2011 14:58:23 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Karel Zak <kzak@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824 bd_link_disk_holder+0x92/0x1ac()
References: <16069.1294853673@localhost> <4D2E4611.90002@redhat.com> <4D2E6129.8000700@ce.jp.nec.com> <20110113110640.GC30719@htj.dyndns.org> <4D2EE156.1050006@redhat.com> <20110113122701.GG16523@nb.net.home> <20110113131216.GF30719@htj.dyndns.org> <20110113132637.GH16523@nb.net.home> <20110113133722.GG30719@htj.dyndns.org>
In-Reply-To: <20110113133722.GG30719@htj.dyndns.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2011 02:37 PM, Tejun Heo wrote:

> So, just don't do it.  Sysfs is for device hierarchy.  Don't try to
> shove pretty looking things there (unless it's something widely agreed
> on and necessary, of course).

Hi,

I think that it is exactly what holders/slaves do - displaying device
hierarchy. So application can check which underlying device are related
and ask them for more info if needed (=> with system specific call,
it can be simple sysfs attribute, ioctl, whatever).

So the only request here is to keep these symlinks correct, nothing more.
Or am I missing anything?

Milan
