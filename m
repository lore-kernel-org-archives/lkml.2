Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab1AKFbD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 00:31:03 -0500
Received: from mail-wy0-f194.google.com ([74.125.82.194]:57535 "EHLO
	mail-wy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab1AKFbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 00:31:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=hVJpgvwQEE3G6rtOygLAPfyDaMIWdiuYOgsxH8f92Ic880wglzdZn3m3MNp4d83XYG
         mQeto74NRrffc1lWDV7vJgFY/kZt3A2lf0HFS3h3YW7IhbiOf8uhgTDKQEKYTxyTq8ZW
         pUTMPZd+8nFjgYKQFPPSpPCf2y1JOhr6PKyJc=
MIME-Version: 1.0
In-Reply-To: <4D245D16.5010702@st.com>
References: <1293111851-7175-1-git-send-email-filippo.arcidiacono@st.com> <4D245D16.5010702@st.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Tue, 11 Jan 2011 00:30:38 -0500
X-Google-Sender-Auth: 4RjAyYs8NfMk8HRqtOQeEIe3GqE
Message-ID: <AANLkTinZCDRVwwchcB85Wock8nBYK1eJrTWPbgJ-roGh@mail.gmail.com>
Subject: Re: [PATCH 1/2] stackprotector: add stack smashing protector generic implementation
To: Carmelo AMOROSO <carmelo.amoroso@st.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Filippo ARCIDIACONO <filippo.arcidiacono@st.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "nico@fluxnic.net" <nico@fluxnic.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

what are you using to test this ?  is there a simple strcpy or similar
code you run as a kernel module that'll allow me to verify ?
-mike
