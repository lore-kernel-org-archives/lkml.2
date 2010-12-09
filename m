Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab0LIRFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:05:30 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53600 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754792Ab0LIRF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:05:28 -0500
Subject: Re: [PATCH 1/7] ideapad: add platform driver for ideapad
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Ike Panhc <ike.pan@canonical.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-acpi@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
In-Reply-To: <1291881410-4759-1-git-send-email-ike.pan@canonical.com>
References: <1291881376-4729-1-git-send-email-ike.pan@canonical.com>
	 <1291881410-4759-1-git-send-email-ike.pan@canonical.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Thu, 09 Dec 2010 09:04:37 -0800
Message-ID: <1291914277.7960.0.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-09 at 15:56 +0800, Ike Panhc wrote:
> Create /sys/devices/platform/Ideapad for nodes of ideapad landing.

Any chance you want to make that 'ideapad'?  It would be a bit more
consistent with all the other stuff in that directory, and will surely
save me some trips over to the shift key. :)

-- Dave

