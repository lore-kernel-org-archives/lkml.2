Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474Ab2CIRdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 12:33:00 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64315 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396Ab2CIRc6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 12:32:58 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo5QGqW8OL10H_PajnWi0JT=UsfX4c6pXJ_hsqXPcd+NPw@mail.gmail.com>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
	<1331018040-30725-8-git-send-email-yinghai@kernel.org>
	<CAErSpo6jqr44JS4Cyfc0cR_TNbo_ETjPJUO=x2gj-Q_x4TckVA@mail.gmail.com>
	<CAE9FiQWPk-s5F5ofO=nU05tnRhmpav+f8Cs_mBG9A-MPuK9stw@mail.gmail.com>
	<CAErSpo5QGqW8OL10H_PajnWi0JT=UsfX4c6pXJ_hsqXPcd+NPw@mail.gmail.com>
Date: Fri, 9 Mar 2012 09:32:57 -0800
X-Google-Sender-Auth: eyNokHul-tQG74DprjQOgeC_PHg
Message-ID: <CAE9FiQXMhEkMBTjnPJkB21ob9L9jNp_-8_h+xo6mOt3fFQ7xQQ@mail.gmail.com>
Subject: Re: [PATCH 07/23] pci, dmar: Update dmar units devices list during hotplug
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        iommu@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 9, 2012 at 9:25 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
> Well, it looks like you can change both save_dev_dmaru() *and*
> get_dev_dmaru() to take a struct pci_dev *.  I assumed that would be
> obvious.

no.

get_dev_dmaru() have to use bus/devfn to retrieve the dev pointer.

Yinghai
