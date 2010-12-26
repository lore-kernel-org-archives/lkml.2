Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab0LZXbQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 18:31:16 -0500
Received: from nm29.bullet.mail.ac4.yahoo.com ([98.139.52.226]:40966 "HELO
	nm29.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752798Ab0LZXbO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 18:31:14 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 919023.85680.bm@omp1049.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=4xxWZCXtOiZTUcpp7fprsY0Jng24B0a2OYZXH4Z3w4g0fLFiHZae49ejYwNU8AVmqepjNcoycACAjhSNJZa+BnG7EbsgmddG3pBg1Rwe3mhQ66S8wjk76+vKUKJ0m00yx8aDb8gJ5vj3VQgvtljrPxBpKAnYCRXmjJQOConi25w=;
Message-ID: <761934.79777.qm@web65716.mail.ac4.yahoo.com>
X-YMail-OSG: 4eVbPG4VM1n6zeMCwyNl9vcFFrvDlvn0v0MJhNjemAfMXVT
 30x2gWI52PyBhymyLeSmKXVgWRKEVNkGZQ8Kbdv.sezo5sP4GDNu4RMq_8ph
 lSZS0A5353k.oERXsSaHVCkzARlPRyiqTPyuNDgdyeJPiZqaGmHNYvDdswki
 mKAHZkDppzzWk9GZOsH5uOjSgEd2UjKCWQgkUtPae1SaP0PGRyBouktTMCtz
 KmudjZn.IP0tjznhvFJRz.56_HmDS1NRcaQixmVxXQw9gnt0f1bOYcIGpm5_
 9UMJrIjb5uoV6tax0azkJkMhkYQm9kNkAGA8smz_X_Gos4xf4TPjTmwxmfMT
 WRucsSrb8X.XofHQLhDrnF7lARqJPT_4qqnaY0QBn4QurFm3xwp1v
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Sun, 26 Dec 2010 15:31:13 -0800 (PST)
From: Tsozik <tsozik@yahoo.com>
Subject: Re: [PATCH 1/1] mct_u232: IOCTL implementation
To: Jesper Juhl <jj@chaosbits.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Greg KH <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1012262255080.20797@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper,

Many thanks for the info. After reading your post I realized that Greg meant that change log comments will be stored in git repository comment section like in any other source control system (e.g. cvs, rcs, ...). So no need to duplicate them in actual file. I will only provide comments in description section of canonical patch format. I'm also wondering if it's OK to provide "git diffs" instead of diffs as a part of patch email? 

Thank you in advance,
 Vadim.

--- On Sun, 12/26/10, Jesper Juhl <jj@chaosbits.net> wrote:

> From: Jesper Juhl <jj@chaosbits.net>
> Subject: Re: [PATCH 1/1] mct_u232: IOCTL implementation
> To: "Tsozik" <tsozik@yahoo.com>
> Cc: "Randy Dunlap" <rdunlap@xenotime.net>, "Greg KH" <gregkh@suse.de>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
> Date: Sunday, December 26, 2010, 5:03 PM
> On Sun, 26 Dec 2010, Tsozik wrote:
> 
> > Randy,
> > 
> > Greg referred to git as to place where change log
> comments are now 
> > checked in. I googled it and found that one can also
> check out latest 
> > kernel source code as opposed to tarball download.
> However, You're 
> > right, looking at 
> > http://kernelnewbies.org/UpstreamMerge/SubmittingPatches
> documentation I 
> > don't see how one can use git to check in comments or
> code directly to 
> > git repository,
> > 
> 
> Only Linus can check code into the final official tree.
> But, you can use 
> git to get a copy of the latest Linus tree (and many other
> trees run by 
> various maintainers and others). Git is also useful for
> maintaining your 
> own local branch with your changes.
> 
> The way it usually works is that you create a patch and
> send it off to 
> some sub-system maintainer via email patch ('git diff'
> generated usually) 
> or via email pull request for your personal repository. The
> sub-system 
> maintainer then merges your patch with his tree and, at a
> later date, 
> submits his tree (including your patch) to Linus.
> 
> Changelog comments are tracked with git. Once your patch is
> accepted it 
> will eventually make its way to Linus' tree and your
> changelog comments in 
> the patch mail (or git commit message - if you send a pull
> request) will 
> eventually turn into a git commit message in the official
> tree. So there's 
> no need to add changelog info in the files themselves.
> Check http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=shortlog
> 
> (or git log after cloning the tree) to see commit
> messages.
> 
> 
> -- 
> Jesper Juhl <jj@chaosbits.net> 
>           http://www.chaosbits.net/
> Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please.
> 
> 


      
