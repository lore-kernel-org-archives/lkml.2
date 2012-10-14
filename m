Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192Ab2JNP5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:57:21 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:58021 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753959Ab2JNP5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 11:57:20 -0400
X-Authenticated: #787645
X-Provags-ID: V01U2FsdGVkX19uD5ho1Sxul7rurJqkLfAXKbAeTHpjjPxKLaS8iI
	cgeK3TzKiozDr1
Message-ID: <507AE0D8.6090909@gmx.net>
Date: Sun, 14 Oct 2012 17:57:12 +0200
From: Witold Szczeponik <Witold.Szczeponik@gmx.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: bhelgaas@google.com, lenb@kernel.org
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH V3 0/3] PNP: Allow PNP resources to be disabled (interface)
References: <50158321.4030007@gmx.net> <201208022340.16948.rjw@sisk.pl> <5055DFB6.6070809@gmx.net> <201209182342.30244.rjw@sisk.pl> <506C6065.3070202@gmx.net>
In-Reply-To: <506C6065.3070202@gmx.net>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/12 17:57, Witold Szczeponik wrote:

[...]

> 
> Len and Bjorn, 
> 
> any chances to include the patches in 3.7?  I checked them 
> against 3.6 and they applied without any change.  Or should 
> I resend them individually? 
> 
> Thanks. 
> 
> --- Witold
> 

Hi Len, hello Bjorn, 

the patches submitted in https://lkml.org/lkml/2012/7/29/85 have
not been objected by anyone, make the code simpler, and fix a 
current problem when using the "/sys/bus/pnp/devices/*/resources" 
interface.  I have been running them since at least Linux 3.0, 
with adapted changes in previous versions.  I have not seen any
regressions and I do not expect any regressions from these
patches. 

Bjorn had reviewed them and I am wondering what I can do to have 
them included in (one of) the next Linux kernel(s).

If there is any information that you need before an inclusion is
possible, just let me know. 

--- Witold
