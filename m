Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab1KKSkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 13:40:19 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48454 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab1KKSkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 13:40:17 -0500
MIME-Version: 1.0
In-Reply-To: <20111109173412.GE14181@aftab>
References: <CAMLZHHTSuHZoPbm_YfB8G05JA+xKCE4+Jmj4NW8mnZUHogQSBA@mail.gmail.com>
	<20111108203116.GF25083@aftab>
	<4EB9A6BC.7050600@zytor.com>
	<F625F33982F5D847987879CC59FF132D6F5B@storexdag03.amd.com>
	<CAMLZHHTu-FNphvt5_L7fxqRpPukfs8nbS71x3GYo5GsPBo5cNw@mail.gmail.com>
	<20111108223744.GA1996@x1.osrc.amd.com>
	<CAMLZHHRc+yNr=6SB7Z1t_hyL+e8a0T-BokyQ+wVUPw-vhd3rQA@mail.gmail.com>
	<20111109173412.GE14181@aftab>
Date: Fri, 11 Nov 2011 12:40:15 -0600
X-Google-Sender-Auth: NW1HpCLZGlqdw5YOW2XiWRauDQE
Message-ID: <CAMLZHHRJdumbbuBtHnAOtLRCzgBrKQw-PHCeeG=WEs5KeKsKGw@mail.gmail.com>
Subject: Re: Geode LX boot fails after x86 microcode revision change
From: Daniel Drake <dsd@laptop.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 9, 2011 at 11:34 AM, Borislav Petkov <bp@amd64.org> wrote:
> On Tue, Nov 08, 2011 at 04:59:05PM -0600, Daniel Drake wrote:
>> On Tue, Nov 8, 2011 at 4:37 PM, Borislav Petkov <bp@alien8.de> wrote:
>> > Yep, just send me /proc/cpuinfo from a working kernel.
>
> Daniel, would you please test? It should work though :-)

Thanks, it boots now.

Daniel
