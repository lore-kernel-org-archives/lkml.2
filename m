Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab2DWQmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:42:43 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61981 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab2DWQml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:42:41 -0400
MIME-Version: 1.0
In-Reply-To: <4F85ED86.8010002@gmx.net>
References: <4F85ED86.8010002@gmx.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 23 Apr 2012 10:42:19 -0600
Message-ID: <CAErSpo7ynK9wWBRTfXSSSp3JtThs7_eTttKVfsHMJbKh7JSK1Q@mail.gmail.com>
Subject: Re: [PATCH V2 0/3] PNP: Allow PNP resources to be disabled (interface)
To: Witold Szczeponik <Witold.Szczeponik@gmx.net>
Cc: lenb@kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 2:45 PM, Witold Szczeponik
<Witold.Szczeponik@gmx.net> wrote:
> Hello everybody,
>
> this simple patch series continues the work begun in commit
> 18fd470a48396c8795ba7256c5973e92ffa25cb3 where ACPI PNP resource templates
> with empty/disabled resources are handled.

For all three patches:

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
