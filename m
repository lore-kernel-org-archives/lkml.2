Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728Ab2ISRRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:17:10 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37566 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570Ab2ISRRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:17:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo7DJgtxCF2ubw4rwxcSQh-BkivQLJDsqJOGU32pcmTTnw@mail.gmail.com>
References: <1347670122-25824-1-git-send-email-yinghai@kernel.org>
	<1347670122-25824-3-git-send-email-yinghai@kernel.org>
	<CAErSpo5LMj=wPwYgJfk97hfx9b03fPHZXEvdR6gV2somBTD+4A@mail.gmail.com>
	<CAE9FiQUxt1kx_SpRWt5eMKvUXuUXwJrd9USeT+WMbCWkDDaQZQ@mail.gmail.com>
	<CAErSpo7DJgtxCF2ubw4rwxcSQh-BkivQLJDsqJOGU32pcmTTnw@mail.gmail.com>
Date: Wed, 19 Sep 2012 10:17:05 -0700
X-Google-Sender-Auth: WEm2UvERJt8vO5XtYck2p0gHgG0
Message-ID: <CAE9FiQW0PpBU0N9VzJyNKK9PvaUwokCYeB6w_j4mcN9EV0geLQ@mail.gmail.com>
Subject: Re: [PATCH] PCI, x86: clear initial value for root info resources
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 6:12 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> yes, but they don't support pci_set_host_bridge_release yet. so they
>> should not meet this problem yet.
>
> Why should we wait to fix that bug until later?  I'm not interested in
> debugging this in the future.  If you fix a bug, you should always try
> to fix other occurrences of the same bug at the same time.

ok, will update the patch.
