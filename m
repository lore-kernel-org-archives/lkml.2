Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab1JASqK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 14:46:10 -0400
Received: from nm8-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.95]:47563 "HELO
	nm8-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752588Ab1JASqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 14:46:06 -0400
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Oct 2011 14:46:06 EDT
X-Yahoo-Newman-Id: 221984.79869.bm@smtp217.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: u3iIGXwVM1lN4Wr_UvQ7vjK98o6kdJGqannNG0X7ZzfFRZ4
 rz5ZED84ejU03Uk4T_kFe20RpeRmlXHLR5Y6FoCeIhIZjR2MpyG7uuI59zbE
 stjFctE2.5WV6uW287KSSfjPB0GX8vFMpZcoM.NxMQw9QIGSpC1lq8mvu3UH
 wFqCV.lFgSIJhIzRGVCP5N3spN0OxeP7Aqkc9qa4afqpLD2U.0xo7eED7rRK
 a9t0oGsiEmKw8mZPOkbRijeBWLq.jgbA0eKcpsFVBWY8oTk38p7DFLBRLrK7
 hTDunCtYUhIeoTYKw5KBPS3.oufJbeGxea3mxNZlgJMcVqwA4W6Es5TICCx8
 ES6Zly5IPr42Q467gjOYkwfI3K5zPnGTRCsT0D_hBUcx9sA7v46zNsRbKr9k
 L6JiwkaX2ydn_ZRTmUfovd2oponmPgmlMXVH8UODH4vOz.gUsD24-
X-Yahoo-SMTP: gvIQca6swBCF5pMq54eC.XuJ8SoqXA5fBgqzSmaH
Date: Sat, 1 Oct 2011 13:40:44 -0500
From: Andy <akwatts@ymail.com>
To: Willy Tarreau <w@1wt.eu>, schwab@linux-m68k.org
Cc: Greg KH <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: hints on how to check your machine for
 intrusion
Message-ID: <20111001184044.GA13608@zeus>
References: <4E8655CD.90107@zytor.com>
 <20110930235924.GA25176@kroah.com>
 <20111001141751.GA8937@zeus>
 <20111001142848.GA27058@kroah.com>
 <20111001165659.GB18690@1wt.eu>
 <20111001171916.GA11989@zeus>
 <20111001175456.GC18690@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111001175456.GC18690@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 07:54:56PM +0200, Willy Tarreau wrote:
>   $ git config tar.umask 022

Andreas/Willy:

It was indeed umask which was skewing the results. Thanks.

Now, I'll wait for Willy's hashes since I can't drill down on
Linus' 2.6 tree beyond 2.6.x.

~ Andy
