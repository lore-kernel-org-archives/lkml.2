Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991Ab1IIWor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 18:44:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759098Ab1IIWop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 18:44:45 -0400
MIME-Version: 1.0
In-Reply-To: <1315518078-30619-1-git-send-email-mason@myri.com>
References: <1315518078-30619-1-git-send-email-mason@myri.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 9 Sep 2011 15:44:21 -0700
Message-ID: <CA+55aFyFXXyEvOs0asgNeCrLzvH+e1zXgOen1rDd9BkB09J5NQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] PCI: PCI-E MPS bug fixes
To: Jon Mason <mason@myri.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse,
  what's the status of this? It does seem like our current PCIe
behavior is rather unsafe.

Should I apply the patches, should I wait for a pull request from you,
should I ignore them because of xyz?

                      Linus

On Thu, Sep 8, 2011 at 2:41 PM, Jon Mason <mason@myri.com> wrote:
> Please include these bug fixes to PCI in 3.1-rc6
>
>
