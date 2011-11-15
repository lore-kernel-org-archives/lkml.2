Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378Ab1KOPdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 10:33:10 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36810 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353Ab1KOPdI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 10:33:08 -0500
MIME-Version: 1.0
In-Reply-To: <20111114183635.GA6316@redhat.com>
References: <20111114183635.GA6316@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 15 Nov 2011 08:29:56 -0700
Message-ID: <CAErSpo4X1-0D1iOm=SuoxaqwWh2sVYFR_1qsZMRB00tBFnSu+Q@mail.gmail.com>
Subject: Re: GHES: Failed to read error status
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        ying.huang@intel.com, kernel-team@fedoraproject.org,
        Matt_Domsch@dell.com
Cc: linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+linux-acpi]

On Mon, Nov 14, 2011 at 11:36 AM, Dave Jones <davej@redhat.com> wrote:
> It appears that there's a problem with Dell poweredge servers
> and GHES judging by the bug reports at
>
> https://bugzilla.redhat.com/show_bug.cgi?id=746755
> https://bugs.launchpad.net/ubuntu/+bug/881164
>
> Is this likely to be something that Dell need to fix in a firmware update,
> or something that the code needs to accomodate ?
>
>        Dave
