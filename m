Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761279Ab2FEAxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 20:53:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50221 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761252Ab2FEAxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 20:53:07 -0400
Message-ID: <4FCD5869.8000306@zytor.com>
Date: Mon, 04 Jun 2012 17:52:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: George Shuklin <george.shuklin@gmail.com>
CC: Casey Schaufler <casey@schaufler-ca.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Why minor is still 8 bit?
References: <4FCC0E6D.9000206@gmail.com> <20120604013504.GU30000@ZenIV.linux.org.uk> <4FCC3151.1040503@gmail.com> <4FCCDE2B.3020306@schaufler-ca.com> <4FCD0591.2050504@gmail.com>
In-Reply-To: <4FCD0591.2050504@gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 11:59 AM, George Shuklin wrote:
> Very simple sample: I'd like to create shared storage to publish volumes
> via ISCSI. ~60Tb of drives, ~2Gb average disk size = 30k disk images.
> Can I just create a bunch of LV and export them by iet or scst? Nope:
> There is a serious limit for amount of active LV per host. Yes, I can
> create filesystem, put images (as file) to that filesystem and publish
> them back, but why FS is needed to do such simple task?

You realize that with that many volumes, a logical volume manager *is* a
filesystem, right?

	-hpa
