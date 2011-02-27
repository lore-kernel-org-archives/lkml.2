Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab1B0QR5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 11:17:57 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62985 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab1B0QR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 11:17:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=om12qeVvw6pj2qykW3Vkxd5nfkIe9i/wkUauDzvtIAHQ+0feXAEA/ZsXCOkyVX9q3u
         zflXt59LfbzdSIu06tAg6UDIRgyWElvqK2Jad7OhO7wB8y1x6iKJxOcc84VAuvD6ohPL
         gwk5WR3hnI7UF8Q5vLmzc+kwyVvxYCiO9H8RQ=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1102160119430.843@x980>
References: <alpine.LFD.2.02.1101182150400.14668@x980>
	<alpine.LFD.2.02.1101190035200.14668@x980>
	<alpine.LFD.2.02.1102160119430.843@x980>
Date: Sun, 27 Feb 2011 17:17:53 +0100
Message-ID: <AANLkTinVCvUkmX3pnSy_Ah3fOm6hV-jAPrQXAQ971xnS@mail.gmail.com>
Subject: Re: [PATCH] intel_idle: disable NHM/WSM HW C-state auto-demotion (v3)
From: Pierre Tardy <tardyp@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-pm@lists.linux-foundation.org, x86@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 7:22 AM, Len Brown <lenb@kernel.org> wrote:
> From: Len Brown <len.brown@intel.com>
>
> Hardware C-state auto-demotion is a mechanism where the HW overrides
> the OS C-state request, instead demoting to a shallower state,
> which is less expensive, but saves less power.
I'm interrested, for pytimechart, to have trace information of what
actual c-state got reached after each idle request.
Do you have any info on how to get that?

Regards
Pierre
