Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab0FWS0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 14:26:52 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:44493 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab0FWS0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 14:26:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=qnWIVLBMPimoEdkAuAi76RFr08HZQy/LwUwbFitZ0qXqY3zOC97VEZN7zm05WyreD+
         H95bsvcXKvcJe6xzVoONQ1bBirFC/aoqf1S2yTVkBYBr7aoVZ2h/sAIxUBCrjCjtXkQ+
         XqctZ+cYTz6GMN4DX+QVstI5D/WUhbzwJSGtQ=
MIME-Version: 1.0
Reply-To: linux@schou.dk
In-Reply-To: <AANLkTiln40Xo3fHbMSkEvdBUtFq8ZWrF57wgRWdU2Juc@mail.gmail.com>
References: <AANLkTimO5PXmJiIPDw82MTA53mLSl-OC0e1SOEh7v8pH@mail.gmail.com> 
	<1276972298.22889.16.camel@obelisk.thedillows.org> <AANLkTimwZFNLBNJWODyzKXwx9CbIorg3OCA53XZchkeN@mail.gmail.com> 
	<1277043970.22889.45.camel@obelisk.thedillows.org> <AANLkTikBTMq3d-Ov65wYLJ_Vw-7Jde4AOwfXcEPB0wLr@mail.gmail.com> 
	<1277129180.22889.64.camel@obelisk.thedillows.org> <AANLkTikW71h7ABVXY21pLL9AeOlmRTfVaSTjJ_6Ma0_R@mail.gmail.com> 
	<AANLkTikCGzUKe9Fy1d0xhberqGFe71lvrQbg5gkQzgf1@mail.gmail.com> 
	<AANLkTikPW9j4H15gq7nl0Tb213R15uIQAnSDi_cTOJre@mail.gmail.com> 
	<1277262047.10818.9.camel@obelisk.thedillows.org> <1277271419.10818.22.camel@obelisk.thedillows.org> 
	<AANLkTiln40Xo3fHbMSkEvdBUtFq8ZWrF57wgRWdU2Juc@mail.gmail.com>
From: Hans Schou <linux@schou.dk>
Date: Wed, 23 Jun 2010 20:26:29 +0200
X-Google-Sender-Auth: yCISdQBE6_oLUEzqpJoOudx0d-k
Message-ID: <AANLkTilBXYuvPWUeCVcA9YIulLDxT91vpCq6b4TrAL41@mail.gmail.com>
Subject: Re: PROBLEM: SIS7019 stops recording after 42 min
To: David Dillow <dave@thedillows.org>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/23 Hans Schou <linux@schou.dk>:

> If the problem is ALSA, how can I then turn it off?

I am quite sure it is turned off:

# dmesg | grep -A 1 ALSA
ALSA device list:
  No soundcards found.

regards/hans
