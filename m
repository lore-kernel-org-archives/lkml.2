Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab0KJSJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:09:53 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37807 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab0KJSJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:09:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OKDdhYl3o39hRQqNDllCjx/6D59Yu07ewc69m5lEFgmq8uZZw3DHALIhXo0r0gGoap
         bJl8a2QCPmt8h4eISB4zwBK2NsYiuW2GgbFKVLluK7XYS+RCyGpejZnxhuXaTiAvEsei
         bep6UMFBMIhOF7cDCHoEMAjcyxxON9YsWyPik=
Subject: Re: [PATCH 0/7] perf trace command-line cleanup
From: Tom Zanussi <tzanussi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com
In-Reply-To: <20101110073236.GA29493@elte.hu>
References: <1289337502-2492-1-git-send-email-tzanussi@gmail.com>
	 <20101109213829.GB7883@ghostprotocols.net> <20101110073236.GA29493@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 12:09:43 -0600
Message-ID: <1289412583.4100.0.camel@elnicho>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 08:32 +0100, Ingo Molnar wrote:
> * Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:
> 
> > Ingo,
> > 
> > 	Please pull from Tom's git tree, I'm traveling and can't do
> > further tests, but all seems cool improvements,
> 
> I cannot pull it - the tree is based against tip:master, and the patches sent in 
> email wont apply.
> 
> Tom, mind rebasing your fixes to perf/urgent [which is really just Linus's latest 
> tree right now], with Arnaldo's Acked-by added to each patch?
> 

Sure, coming up...

Tom


