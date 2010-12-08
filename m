Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab0LHDGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 22:06:34 -0500
Received: from claw.goop.org ([74.207.240.146]:49849 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883Ab0LHDGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 22:06:33 -0500
Message-ID: <4CFEF637.4020203@goop.org>
Date: Tue, 07 Dec 2010 19:06:31 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Joerg Roedel <joerg.roedel@amd.com>, Borislav Petkov <bp@amd64.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH 1/3] x86-32: Separate 1:1 pagetables from swapper_pg_dir
References: <20101111141358.GA4641@kroah.com> <1289488576-18117-2-git-send-email-joerg.roedel@amd.com> <20101207210512.GA14849@kroah.com>
In-Reply-To: <20101207210512.GA14849@kroah.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2010 01:05 PM, Greg KH wrote:
> On Thu, Nov 11, 2010 at 04:16:14PM +0100, Joerg Roedel wrote:
>> commit fd89a137924e0710078c3ae855e7cec1c43cb845 upstream
> applied, thanks.

This will need as well 5b5c1af104ab5adec1be9dcb4c787492d83d8d83 to
prevent Xen regressions.

    J
