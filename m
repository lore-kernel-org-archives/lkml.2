Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab2BPRyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 12:54:39 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:58310 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751525Ab2BPRyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 12:54:38 -0500
Message-ID: <1329414876.11146.2.camel@joe2Laptop>
Subject: Re: [PATCH 4/4] PCI: quirk print dev name with duration
From: Joe Perches <joe@perches.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arjan van de Ven <arjan@infradead.org>
Date: Thu, 16 Feb 2012 09:54:36 -0800
In-Reply-To: <CAErSpo57hL9dFyFDvdEQcLKCPOeCh3MY3UCURvrXKPpA8W3y3A@mail.gmail.com>
References: <1329369296-4255-1-git-send-email-yinghai@kernel.org>
	 <1329369296-4255-5-git-send-email-yinghai@kernel.org>
	 <1329369930.5082.4.camel@joe2Laptop>
	 <CAE9FiQUK8m5KKb0or59wH7BD6Eo5ddx9NaF7vszNeR0T3UYMRw@mail.gmail.com>
	 <1329371019.5082.9.camel@joe2Laptop> <1329376076.7658.4.camel@joe2Laptop>
	 <CAErSpo57hL9dFyFDvdEQcLKCPOeCh3MY3UCURvrXKPpA8W3y3A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-16 at 09:49 -0800, Bjorn Helgaas wrote:
> If you do change, remember that dev_dbg() is different from
> printk(KERN_DEBUG) in that printk(KERN_DEBUG) is always compiled-in
> and always goes to the dmesg, but dev_dbg() is only compiled in when
> DEBUG is defined, so dev_printk(KERN_DEBUG) would be a more direct
> replacement for printk(KERN_DEBUG).

Correct.

Which is why I usually add #define DEBUG or an
equivalent CONFIG option before those are converted.
Doing so allows control via dynamic debug.


