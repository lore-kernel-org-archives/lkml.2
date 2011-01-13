Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab1AMNw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 08:52:27 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33352 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756785Ab1AMNwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 08:52:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bfA0XCEEp2R47fwrgm4MiUHqP6BaXtkv38WPTHn+CAblU/9I8EokmLha8Js4WT7Vvo
         0Fhks111w5M5Wq0TP13UjhTbJnHaX2BWHnbyaoBN7bqyNwWd0v165Lqi0bc2d28AOIon
         RofKD5mrOx3CSGtDgkMVrwU8Uhd2KcGbgIP8Q=
Date: Thu, 13 Jan 2011 14:52:10 +0100
From: Tejun Heo <tj@kernel.org>
To: Karel Zak <kzak@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824
 bd_link_disk_holder+0x92/0x1ac()
Message-ID: <20110113135210.GH30719@htj.dyndns.org>
References: <16069.1294853673@localhost>
 <4D2E4611.90002@redhat.com>
 <4D2E6129.8000700@ce.jp.nec.com>
 <20110113110640.GC30719@htj.dyndns.org>
 <4D2EE156.1050006@redhat.com>
 <20110113122701.GG16523@nb.net.home>
 <20110113131216.GF30719@htj.dyndns.org>
 <20110113132637.GH16523@nb.net.home>
 <20110113133722.GG30719@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110113133722.GG30719@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 02:37:22PM +0100, Tejun Heo wrote:
> >  It seems that dependencies (holders/slaves) between devices is pretty
> >  generic thing. Why do you think that we need claimer-specific method?
> >  The /sys filesystem is better that ictls in many ways.

Also, one more thing.  In btrfs, there's no block device for the
master device.  You can add the slaves directory somewhere and your
choice would be as good as any other's but it just will not be generic
while being superflous exactly the same way it's superflous for md and
dm devices.

Thanks.

-- 
tejun
