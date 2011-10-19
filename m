Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab1JSPm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 11:42:27 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56604 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab1JSPm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 11:42:26 -0400
MIME-Version: 1.0
In-Reply-To: <20111019152132.GH29653@arm.com>
References: <20111019152132.GH29653@arm.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 19 Oct 2011 16:42:05 +0100
X-Google-Sender-Auth: UaM6H9r936COxfaO68jWtgUdM_c
Message-ID: <CAHkRjk5otn37MCYjiDhwAuq-HdzabnTMDvxrC0C2y5H+ZjBgjA@mail.gmail.com>
Subject: Re: Memory leak in isp1760-hcd.c
To: Arvid Brodin <arvid.brodin@enea.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 October 2011 16:21, Catalin Marinas <catalin.marinas@arm.com> wrote:
> I get the following kmemleak report coming from the ISP1760 driver:

BTW, that's Linux 3.1-rc9.

-- 
Catalin
