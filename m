Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559Ab2GMTKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 15:10:22 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:42204 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab2GMTKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 15:10:21 -0400
Message-ID: <5000729A.2050401@hp.com>
Date: Fri, 13 Jul 2012 13:10:18 -0600
From: Khalid Aziz <khalid.aziz@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mike Waychison <mikew@google.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
        tony.luck@intel.com, keescook@chromium.org, gong.chen@linux.intel.com
Subject: Re: [PATCH] Add missing attributes to EFI variable attribute print
 out from sysfs
References: <20120713153827.GA8007@hp.com> <20120713154645.GA16059@srcf.ucam.org> <5000604F.80804@hp.com> <CAGTjWtA0LmQ-90zjYf0nho_LEra8nx32M1R7E6o=3S68UjfEHw@mail.gmail.com>
In-Reply-To: <CAGTjWtA0LmQ-90zjYf0nho_LEra8nx32M1R7E6o=3S68UjfEHw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2012 12:04 PM, Mike Waychison wrote:

> You can probably save the wrap by copying out var->Attributes into a local.

Yes, you are right. It will work in this case. I am considering the general
case of very long name for a constant causing issues with line wrap in
more complex code, or just plain being a pain to type such a long name (one
of these constants is ~50 characters).

--
Khalid Aziz
khalid.aziz@hp.com

