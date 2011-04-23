Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab1DWNpR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 09:45:17 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51504 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab1DWNpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 09:45:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tQ8loogEfJxqFjOmk8/JVSFegM4Nh8zvytKA4yTb8QuNVvLS01TYzif1RKgCgnrrBE
         zdM/pF2Eqg+t++G3crsOxF9A4ZpDHVnbGo74ax585ZBftbDW9yRF0354D9x57YW1sywf
         qpjwCEpDJwnMaPhHXFH1ToUFwbX/Np5Ah/CXg=
MIME-Version: 1.0
In-Reply-To: <4DB1AED0.60600@gmail.com>
References: <inhgjs$54a$1@dough.gmane.org>
	<4D9C84D5.6090303@gmail.com>
	<20110406175217.GC4987@ghostprotocols.net>
	<201104062248.23853.tim@klingt.org>
	<4D9CE610.4020603@gmail.com>
	<4D9CECF5.3090309@gmail.com>
	<4DB1AED0.60600@gmail.com>
Date: Sat, 23 Apr 2011 21:45:14 +0800
Message-ID: <BANLkTimosBfOBsUWQaimT0O53=pALx54AA@mail.gmail.com>
Subject: Re: [2.6.39-rc2] perf top fails to mmap - bisected to 70db7533
From: Lin Ming <minggr@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Tim Blechmann <tim@klingt.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 23, 2011 at 12:37 AM, David Ahern <dsahern@gmail.com> wrote:
> I know you've been busy with other stuff the past few weeks, but have
> you had a chance to look into this? Basically, perf in 2.6.39 is broken
> when trying to profile a process (-p argument to record or top).

Let me take a look at this.

Lin Ming

>
> David
