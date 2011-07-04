Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab1GDSqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 14:46:46 -0400
Received: from smtp-out.google.com ([74.125.121.67]:49348 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab1GDSqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 14:46:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=VmBDG7d1W6EAsuAPtuhWVv2TtVgRAWr/ZuaxJaiAmICs5gidY/8VwctWcwFqm03Jl
	qhd7L07sbNx49IRdVx1qQ==
MIME-Version: 1.0
In-Reply-To: <1309334273.6368.1.camel@phoenix>
References: <1309334273.6368.1.camel@phoenix>
From: Mike Waychison <mikew@google.com>
Date: Mon, 4 Jul 2011 11:46:20 -0700
Message-ID: <CAGTjWtCzC=bZue1g885cmkH-EHKFb4Lf=JqoyP5QQz2b=xOdEw@mail.gmail.com>
Subject: Re: [PATCH] firmware: gsmi: remove sysfs entries when unload the module
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Duncan Laurie <dlaurie@google.com>,
        Aaron Durbin <adurbin@google.com>, Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 12:57 AM, Axel Lin <axel.lin@gmail.com> wrote:
>
> This patch removes sysfs entries in gsmi_exit() and gsmi_init() error path.
>
> Also move the driver successfully loaded message to the end of gsmi_init()
> and return proper error if register_efivars() fails.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mike Waychison <mikew@google.com>

Greg, can you pick this up in drivers-core?
