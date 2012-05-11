Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab2EKJuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 05:50:14 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63820 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932288Ab2EKJuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 05:50:10 -0400
MIME-Version: 1.0
In-Reply-To: <20120511104341.561ad95b@pyramind.ukuu.org.uk>
References: <1336711142-26788-1-git-send-email-levinsasha928@gmail.com> <20120511104341.561ad95b@pyramind.ukuu.org.uk>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Fri, 11 May 2012 11:49:48 +0200
Message-ID: <CA+1xoqdp3N=hxF-bq0vCwUcyLuZ9wbpFiRJT2MjeBx=xQNgDJQ@mail.gmail.com>
Subject: Re: [PATCH] gma500: fix build when ACPI isn't set
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: airlied@linux.ie, alan@linux.intel.com, kirill.shutemov@linux.intel.com,
        airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 11:43 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> Not btw that I imagine you could run a non ACPI kernel on a box new
> enough to have a GMA500 8)

Probably not, but I saw more #ifdef CONFIG_ACPI below and assumed
there's a good reason for that.

Out of curiously, is a scenario where a GMA500 is assigned to a KVM
guest which doesn't have ACPI support plausible?
