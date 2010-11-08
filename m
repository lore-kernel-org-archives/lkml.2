Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab0KHRRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 12:17:14 -0500
Received: from web31801.mail.mud.yahoo.com ([68.142.207.64]:20880 "HELO
	web31801.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754541Ab0KHRRN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 12:17:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=YUBBFMrPzDLaw/kOkyYcAeyRIrmThwfI8LJAWHBydJiGzAnfJ5tR2VgtxLLdTyz9GQ6G5HDuo9MKBzf5utWfb1b9YSJc58Djc+GzP5CM3e8z6xTpsq+ZZfapw2eBoojLzBrcvCBE7CpkLqbQhbdj1cUkrfqagaAVUv8M6jdpHos=;
Message-ID: <836081.29883.qm@web31801.mail.mud.yahoo.com>
X-YMail-OSG: jH8Rru8VM1np_B4RP4tpf2VikbybjQYUt4aexu5BF9RPxBw
 0zrpRm5TwUizqiKSwux3Ic8HF4NIlPoRKxZvZdPgQ0a1Lt7qy0Kr1qzZ8ZQ.
 uhRocwT7r50ksQGMZjVw.Iln6FAwBZ21LPSua76aGiInJu1Cim96HyPRfqI0
 EmiZAMn4KNkWGhJBS5IVkteGpaWfFZHd7rcJaahckWl0qxhJ0sgfVzmFG1pr
 kj2XHMeMRhp6ZxFhE6be7PH.V7EWia__oO7o42tYTBanRtP8cSii5jtaTtxo
 Jee9Y.ws_KQ4CYIhm5Qp9yIos5HUgYsurYWILyFvwz4S3DtAa0otFu9973X2
 i83DciptiYBjjwP553yZzPaslWKF_K4zD2VY-
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.285259
Date: Mon, 8 Nov 2010 09:17:08 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH] [USB] UAS: Rename urbs by pipe
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101108112204.GH4173@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 11/8/10, Matthew Wilcox <willy@linux.intel.com> wrote:
> -0700, Luben Tuikov wrote:
> > The reason to do this is to accommodate sending
> > different IU types using the existing
> > infrastructure.
> 
> Applied, with a modified changelog entry ...

Again, where is it applied and what is the (new) modified changelog entry? Why would you leave this detail out in your response to the patch?

> 
> >      struct urb *data_out_urb;
> >      struct list_head list;
> >  };
> >  
> > -/* I hate forward declarations, but I actually have a
> loop */
> >  static int uas_submit_urbs(struct scsi_cmnd
> *cmnd,
> >         
>         struct uas_dev_info
> *devinfo, gfp_t gfp);
> >  
> 
> Except for this spurious chunk.

Sorry, please help us understand: You'll LEAVE a self-gratifying, narcissistic and pompous statement like "I hate forward-declarations"? Why would you use such a strong word? Why would you "hate"? How about: "I don't like" or "I know lk style discourages", etc. Why would you add /one more/ "hate" word into the kernel?

I think everyone sees why this forward-decl is needed.

I wonder if the relation of the number of the "hate" word in the linux kernel versus time correlates to something, anything? Now that's easier to track and analyze in time using git.

Compared to people losing their homes and jobs nowadays, I'll take a forward declaration any time of day and night.

Bottom line: please consider the patch as is.

