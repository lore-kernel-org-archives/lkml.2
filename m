Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab1CNFEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 01:04:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51755 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993Ab1CNFEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 01:04:09 -0400
Message-ID: <4D7DA16F.5010601@kernel.org>
Date: Sun, 13 Mar 2011 22:02:39 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tim Hockin <thockin@google.com>
CC: Mike Waychison <mikew@google.com>, Greg KH <greg@kroah.com>,
        Matt Domsch <Matt_Domsch@dell.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        San Mehat <san@google.com>
Subject: Re: [PATCH v2 12/12] driver: Google Memory Console
References: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com> <20110312014358.6133.34911.stgit@mike.mtv.corp.google.com> <4D7D9F92.5010604@kernel.org> <AANLkTik5iAPou_bPa4xk6iR27sOk2yrexaaTUe-g=VEe@mail.gmail.com>
In-Reply-To: <AANLkTik5iAPou_bPa4xk6iR27sOk2yrexaaTUe-g=VEe@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2011 09:58 PM, Tim Hockin wrote:
> "Sufficient" or not, that's how the BIOSes we've got work.  We can't
> retrofit that.

Uhm... what about, say, a DMI signature?

	-hpa
