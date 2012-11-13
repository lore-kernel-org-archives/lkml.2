Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab2KMS7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:59:41 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:56915 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687Ab2KMS7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:59:39 -0500
MIME-Version: 1.0
In-Reply-To: <50A205C902000078000A7ECF@nat28.tlf.novell.com>
References: <1352781547-9433-1-git-send-email-acooks@gmail.com> <50A205C902000078000A7ECF@nat28.tlf.novell.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 13 Nov 2012 11:59:16 -0700
Message-ID: <CAErSpo4WtLcMwyCHJ5rkJNhc6g-U9A=uaBzBP6HhtGUsRUn8pQ@mail.gmail.com>
Subject: Re: [PATCH] Add missing license for ioapic module.
To: Jan Beulich <JBeulich@suse.com>
Cc: Andrew Cooks <acooks@gmail.com>, open list <linux-kernel@vger.kernel.org>,
        "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 12:33 AM, Jan Beulich <JBeulich@suse.com> wrote:
>>>> On 13.11.12 at 05:39, Andrew Cooks <acooks@gmail.com> wrote:
>> config PCI_IOAPIC turned into a tristate in commit
>> b95a7bd700466c10fda84acbd33f70cf66ec91ce, but no module license is specified.
>> This adds the missing module license.
>>
>> Signed-off-by: Andrew Cooks <acooks@gmail.com>
>
> Acked-by: Jan Beulich <jbeulich@suse.com>

I applied this to my pci/misc branch as v3.8 material.  Thanks!

Bjorn
