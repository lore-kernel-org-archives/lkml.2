Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab1E0Q3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 12:29:23 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35614 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab1E0Q3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 12:29:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DELHVMMGsCEbCD2NR/hbXjQpFZDml2zvlTA/N1qDngKwYUATpGkrB3/9LyZpCdwnw4
         KYh2U6ZgZeM2jzdZAblqWFFMUbCPnVN0KUtlGJVxqlVWCnhUEUXk3AKNi3WnoxA8BwuE
         yjF6qrGI+mmVlnhCMAgX5dv1MtYbt/ayfNjUE=
MIME-Version: 1.0
In-Reply-To: <20110527080051.GB19300@elte.hu>
References: <4DDF21DE.9040705@jp.fujitsu.com>
	<4DDF23F5.1090206@jp.fujitsu.com>
	<BANLkTinCRX3YOXwuphRTBS=OcHuC07a1jw@mail.gmail.com>
	<20110527080051.GB19300@elte.hu>
Date: Fri, 27 May 2011 09:29:20 -0700
Message-ID: <BANLkTimtcXNjzeRM+cX22fUEFZ5stk8Z3g@mail.gmail.com>
Subject: Re: [PATCH 07/12] x86, mce: introduce mce_gather_info()
From: Tony Luck <tony.luck@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 1:00 AM, Ingo Molnar <mingo@elte.hu> wrote:
> At minimum an explanation should be put into the code. Small, hidden
> dependencies might be common job security moves in the closed source
> world but this is open source ;-)

Seto-san,

Perhaps this more descriptive comment for you new mce_gather_info()
function would help:

/*
 * Collect all global (w.r.t. this processor) status about this machine
 * check into our "mce" struct so that we can use it later to assess
 * the severity of the problem as we read per-bank specific details.
 */
