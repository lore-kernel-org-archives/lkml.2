Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab2JUJJW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 05:09:22 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:33520 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751757Ab2JUJJU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 05:09:20 -0400
Subject: Re: Initial report on F2FS filesystem performance
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Vyacheslav Dubeyko <slava@dubeyko.com>
In-Reply-To: <20121020192215.GB555@elf.ucw.cz>
Date: Sun, 21 Oct 2012 13:09:05 +0400
Cc: Sooman Jeong <77smart@hanyang.ac.kr>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <E0328919-ACAA-4052-B922-952AFA375FD8@dubeyko.com>
References: <1350360423154.2800.144.00.1.77smart@hanyang.ac.kr> <20121020192215.GB555@elf.ucw.cz>
To: Pavel Machek <pavel@ucw.cz>
X-Mailer: Apple Mail (2.1085)
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 46.39.244.28 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 20, 2012, at 11:22 PM, Pavel Machek wrote:

> On Tue 2012-10-16 13:07:03, Sooman Jeong wrote:
>> 
>> This is a brief summary of our initial filesystem performance study of f2fs against existing two filesystems in linux: EXT4, NILFS2, and f2fs.
>> 
> 
> Hmm, flashes are actually optimized for VFAT, right? Can you compare
> against that?
> 

Do you mean SD-cards? Because, as I can understand, "raw" flash (I mean NAND chip) hasn't any special filesystem-related optimization. Moreover, as I know, this optimization takes place in the begin of device (because FAT metadata is placed in the volume's begin). But if you have several partition on a device then you haven't any optimizations for second and next FAT partitions. So, in-place modified metadata of f2fs is placed in the begin of the volume also.

Or, maybe, do you mean some another special optimization for VFAT? 

> What about something more complex like "untar of kernel tree"?
> 

Yes, it is very interesting use-case. Maybe, kernel compilation can be complimentary synthetic benchmark. :-)

With the best regards,
Vyacheslav Dubeyko.

> Ouch and... thanks for doing this.
> 									Pavel     
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

