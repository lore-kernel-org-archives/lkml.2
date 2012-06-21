Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120Ab2FUDAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 23:00:39 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34731 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757995Ab2FUDAi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 23:00:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120615001635.GA2694@Pilar>
References: <20120610163813.GA5721@Pilar.maths.private.cam.ac.uk>
 <20120615022641.1556677f@garik> <20120615001635.GA2694@Pilar>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 20 Jun 2012 20:00:17 -0700
X-Google-Sender-Auth: NrIC_bRMqDBCnJS0DHpeuLrbW0I
Message-ID: <CA+55aFwr1KNwVs3nxD_FuzQFVKG2cMXVxA=sgzwZdYX7kcT=7Q@mail.gmail.com>
Subject: Re: 3.5.0-rc2 bisected regression: Can't change brightness on Vaio laptop
To: "Carlos R. Mafra" <crmafra@gmail.com>, Len Brown <len.brown@intel.com>
Cc: Igor Murzov <intergalactic.anonymous@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len,
 I assume this regression fix is in some ACPI tree pending?

            Linus

On Thu, Jun 14, 2012 at 5:16 PM, Carlos R. Mafra <crmafra@gmail.com> wrote:
> On Fri, 15 Jun 2012 at  2:26:41 +0400, Igor Murzov wrote:
>> Please follow the discussion here:
>> https://bugzilla.kernel.org/show_bug.cgi?id=43168
>
> I tested the patch from Zhang Rui on comment #15 and it fixes
> the issue in the latest mainline.
