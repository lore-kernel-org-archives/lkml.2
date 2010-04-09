Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab0DIU65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 16:58:57 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35469 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218Ab0DIU6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 16:58:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=NfQNttWN3Esg5oh0namjNFZMcmaoPvI9OdgbEpO+ANRTINvUBMqt26YJceIYsjfcyC
         I8Rl22lgOiXLWWO5hoclQR2xAltl+duCw5NSpC4I9cCyNHyZXLAklh9dFydkZtxw7B+c
         DGYQVdEx7G2uukphmS4NhHsFxANn9tvXiuuX0=
MIME-Version: 1.0
In-Reply-To: <4BBECED7.4010004@st.com>
References: <4BBECED7.4010004@st.com>
Date: Fri, 9 Apr 2010 13:58:54 -0700
X-Google-Sender-Auth: 2ae9dd994e6e726e
Message-ID: <x2p1f1b08da1004091358z1d185aacya6c0fa2f55322fc7@mail.gmail.com>
Subject: Re: re-adding clocksource_get_next ?
From: john stultz <johnstul@us.ibm.com>
To: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 8, 2010 at 11:53 PM, Giuseppe CAVALLARO
<peppe.cavallaro@st.com> wrote:
> Hello!
> this function was removed in the past but I've not clear all the details.
> While testing LLTng, I wrote the patch, in attachment, that re-adds it
> again.
> The clocksource_get_next returns the first clock source available
> (without looking at the rating).
> In my environment, a clock source is a TMU channel (e.g. TMU1) and,
> indeed, clocksource_get_next works fine.

Could you provide some more details as to why you need raw access to
the clocksource, instead of using something like ktime_get(),
getrawmonotonic() or sched_clock()?

thanks
-john
