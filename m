Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965398Ab2JCR5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 13:57:49 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60434 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932787Ab2JCR5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 13:57:47 -0400
MIME-Version: 1.0
In-Reply-To: <1349286695-26713-6-git-send-email-yinghai@kernel.org>
References: <506C3B11.9010009@redhat.com>
	<1349286695-26713-1-git-send-email-yinghai@kernel.org>
	<1349286695-26713-6-git-send-email-yinghai@kernel.org>
Date: Wed, 3 Oct 2012 10:57:46 -0700
X-Google-Sender-Auth: 4YyM3phh8EyyE-0VvKHirHSLSNM
Message-ID: <CAE9FiQVZuo7UwnF9UFTEH-9+yrt5GfPk6G+tU09xNOg6PFjfxA@mail.gmail.com>
Subject: Re: [PATCH 5/5] ixgbe: add driver set_max_vfs support
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>, yuvalmin@broadcom.com,
        bhutchings@solarflare.com, gregory.v.rose@intel.com,
        Yinghai Lu <yinghai@kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.r.fastabend@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 10:51 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> Need ixgbe guys to close the loop to use set_max_vfs instead
> kernel parameters.

Sorry, I should put RFC in the subject line for this one.

Thanks

Yinghai
