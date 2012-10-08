Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab2JHXxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 19:53:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43288 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab2JHXxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 19:53:47 -0400
MIME-Version: 1.0
In-Reply-To: <1349716293-16723-2-git-send-email-bp@amd64.org>
References: <1349716293-16723-1-git-send-email-bp@amd64.org>
	<1349716293-16723-2-git-send-email-bp@amd64.org>
Date: Mon, 8 Oct 2012 16:53:46 -0700
X-Google-Sender-Auth: HJCSQ7HSi0GP9fDdgntu70jKMkw
Message-ID: <CA+8MBb+LgCSmV_J-ZeRXuBF_F3qPvUzkvYCC9vo7mugGDNSG7Q@mail.gmail.com>
Subject: Re: [PATCH 1/6] x86, RAS: Add a barebones RAS subtree
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
Cc: EDAC devel <linux-edac@vger.kernel.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 8, 2012 at 10:11 AM, Borislav Petkov <bp@amd64.org> wrote:
> +config X86_RAS
> +       def_bool y
> +       prompt "X86 RAS features"
> +       ---help---
> +       A collection of Reliability, Availability and Serviceability software
> +       features which enable hardware error logging and reporting. Leave it
> +       at 'y' unless you really know what you're doing.
> +

The intent of "X86_RAS" is just to show/hide all the menu
options for the individual features - which will all use
          depends on X86_RAS
right? Having this set to "y" doesn't actually enable any of
the features - they all have their own CONFIG_* variables.

Perhaps we could make that clearer in the help text? And
ditch the "Leave it at 'y' ... ", I don't think it helps anyone.

-Tony
