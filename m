Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab2G0BG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 21:06:28 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:63588 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab2G0BG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 21:06:26 -0400
MIME-Version: 1.0
In-Reply-To: <1343345980-32397-1-git-send-email-astiegmann@vmware.com>
References: <1343345980-32397-1-git-send-email-astiegmann@vmware.com>
Date: Thu, 26 Jul 2012 21:06:25 -0400
Message-ID: <CA+5PVA6RFthz5vjf-0BOogocMEwVKn5uE2q1_frjPFoVeUPACg@mail.gmail.com>
Subject: Re: [vmw_vmci 00/11] VMCI for Linux
From: Josh Boyer <jwboyer@gmail.com>
To: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        pv-drivers@vmware.com, vm-crosstalk@vmware.com, cschamp@vmware.com,
        gregkh@linuxfoundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 7:39 PM, Andrew Stiegmann (stieg)
<astiegmann@vmware.com> wrote:
>  drivers/misc/Kconfig                      |    1 +
>  drivers/misc/Makefile                     |    1 +
>  drivers/misc/vmw_vmci/Kconfig             |   16 +

Is there a reason this isn't going into staging first?  The Hyper-V
drivers went through staging and that actually seemed to work fairly
well.

josh
