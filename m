Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab1CAOzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 09:55:46 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43936 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab1CAOzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 09:55:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rQN72Qj/8UVDtQst4QBXMwV6ww6E0fRyoaABP8gYW1EPWUHAmwqQgo9FcNKPFQCS8l
         71Ng6W8vtPNu3cMOZC805abRPuQ2euI9MqbT1IVus1fAlpCkOr2bfyEseCOV5aJpdw9B
         3ZAyq8fAlh4ldEQK5bcIb/KvusOQAMJ91HZSE=
MIME-Version: 1.0
In-Reply-To: <4D67E286.8010907@dcl.info.waseda.ac.jp>
References: <1298388507-19774-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	<4D63D685.2010401@dcl.info.waseda.ac.jp>
	<1298389415.2217.243.camel@twins>
	<20110222182206.GB1799@nowhere>
	<4D648A65.2040107@dcl.info.waseda.ac.jp>
	<4D667D60.5010903@dcl.info.waseda.ac.jp>
	<20110224165014.GB1840@nowhere>
	<4D67E286.8010907@dcl.info.waseda.ac.jp>
Date: Tue, 1 Mar 2011 15:55:43 +0100
Message-ID: <AANLkTikUGO=Obm7Ue4VzEueQ7DERPiwci1VV9NmKZf1u@mail.gmail.com>
Subject: Re: [PATCH] perf lock: clean the options for perf record
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        h.mitake@gmail.com, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 26, 2011 at 02:10:30AM +0900, Hitoshi Mitake wrote:
> It seems that I was too preprocessed with the method and
> forgot the purpose...
>
> Maybe the things like simple lockstat visualizer or
> special diff between two lockstat snapshots are
> useful for the first looking at big picture.
> I feel that they have worth to write and test.

Indeed they sound like good ideas. Being able to do a diff
on locks profiles would be useful to compare two changes on
the kernel.
