Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab2BZTxW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 14:53:22 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40793 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab2BZTxV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 14:53:21 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo6wSmWBEr4-pKLUPwJAHE0FUFt1O+QzQHrJVdDpaHVq0A@mail.gmail.com>
References: <1330155147-15118-1-git-send-email-yinghai@kernel.org>
	<CAErSpo6wSmWBEr4-pKLUPwJAHE0FUFt1O+QzQHrJVdDpaHVq0A@mail.gmail.com>
Date: Sun, 26 Feb 2012 11:53:20 -0800
X-Google-Sender-Auth: O7STyZifjrtcUvDpkudUik5ycdc
Message-ID: <CAE9FiQXQR+Ncun_27GA_bR_SuDcVw=qoqYpC-mNzL6o11BWAnA@mail.gmail.com>
Subject: Re: [PATCH 1/2] PCI: Separate host_bridge code out from probe.c
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 25, 2012 at 8:17 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Sat, Feb 25, 2012 at 12:32 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> +void add_to_pci_host_bridges(struct list_head *list)
>
> I'd prefer to pass a "struct pci_host_bridge *" here instead of a
> "struct list_head *".  That way the compiler can check a little more.

ok, let me check it.

Yinghai
