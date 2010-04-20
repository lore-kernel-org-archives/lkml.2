Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab0DTRUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 13:20:33 -0400
Received: from adelie.canonical.com ([91.189.90.139]:49130 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab0DTRUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 13:20:31 -0400
Date: Tue, 20 Apr 2010 11:20:24 -0600
From: Alex Chiang <achiang@canonical.com>
To: Jerone Young <jerone.young@canonical.com>
Cc: lenb@kernel.org, colin.king@canonical.com, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [PATCH] ACPI: DMI init_set_sci_en_on_resume for multiple
 Lenovo ThinkPads
Message-ID: <20100420172024.GC5573@canonical.com>
Mail-Followup-To: Alex Chiang <achiang@canonical.com>,
	Jerone Young <jerone.young@canonical.com>, lenb@kernel.org,
	colin.king@canonical.com, linux-acpi@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
References: <20100420140314.GA5573@canonical.com>
 <1271782601.25170.105.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271782601.25170.105.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jerone Young <jerone.young@canonical.com>:
> Don't think this patch should go in as Lenovo is issuing a BIOS to
> address this issue. On these Thinkpads listed and more. Seems to add
> uneeded quirks in my opinion.

Sure, we'll let Len decide if he wants to take it or not. I'm ok
with that.

> Though some over all patch may be good for all machines. As Windows
> seems to be setting this bit on it's own.

Yes, that's what Matthew's patch does.
	http://thread.gmane.org/gmane.linux.acpi.devel/45635

/ac

