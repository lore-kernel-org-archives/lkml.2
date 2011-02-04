Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab1BDR55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 12:57:57 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:62501 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab1BDR54 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 12:57:56 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <19788.15984.732695.435587@quad.stoffel.home>
Date: Fri, 4 Feb 2011 12:59:12 -0500
From: "John Stoffel" <john@stoffel.org>
To: Nicolas de =?iso-8859-1?Q?Peslo=FCan?= 
	<nicolas.2p.debian@gmail.com>
Cc: John Stoffel <john@stoffel.org>, linux-kernel@vger.kernel.org,
        mmarek@suse.cz, linux-kbuild@vger.kernel.org
Subject: Re: 2.6.38-rc3 - make deb-pkg bombs out
In-Reply-To: <4D4BB286.6090500@gmail.com>
References: <19784.18282.668305.184521@quad.stoffel.home>
	<19787.9875.652.181110@quad.stoffel.home>
	<4D4BB286.6090500@gmail.com>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Nicolas" == Nicolas de Pesloüan <nicolas.2p.debian@gmail.com> writes:

Nicolas> Le 03/02/2011 23:05, John Stoffel a écrit :
>>>>>>> "John" == John Stoffel<john@stoffel.org>  writes:
>> 
>> I've updated this email to include the maintainer and the linux-kbuild
>> mailing list.
>> 
John> I've been trying to do a 'make deb-pkg' on 2.6.38-rc? and not
John> having any luck.  I was going to report this error for -rc2, but
John> saw -rc3 this morning so I grabbed it and tried it out.
>> 
John> I can successfully build the kernel on x86_64 (Ubuntu 10.10
John> system, dual core Athlon, 4gb RAM, current directory mounted via
John> NFS), but when I do:
>> 
John> fakeroot make O=/var/tmp/build deb-pkg
>> 
>> Turns out the problem is with the "O=/var/tmp/build" since it works to
>> build the deb-pkg target in the current directory just fine, using the
>> same .config and same arguements.
>> 
>> I guess I'll start to bisect this and see when it last worked.
>> Looking at the scripts/package/builddeb script, it just needs to be
>> updated to use the O=/some/path in the find command.  I think.  But I
>> don't know the build system at all.

Nicolas> I submitted a patch that fix this problem on January 24th.

Nicolas> http://www.spinics.net/lists/linux-kbuild/msg04131.html

Nicolas> Despite a Tested-by: and an Acked-by:, this patch apparently
Nicolas> didn't reach main line until now.

Thanks for the quick reply.  I'm doing a test build now, but I suspect
it will work just fine.  

John
