Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab0DARfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 13:35:08 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:9485 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845Ab0DARfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 13:35:03 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Ozgur Yuksel <ozgur.yuksel@oracle.com>
Subject: Re: [Bugme-new] [Bug 15621] New: BUG: unable to handle kernel paging request - comm: pccardd
Date: Thu, 1 Apr 2010 11:34:13 -0600
User-Agent: KMail/1.9.10
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Dmitry Torokhov <dtor@mail.ru>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <bug-15621-10286@https.bugzilla.kernel.org/> <201003301711.00351.bjorn.helgaas@hp.com> <20100401091808.GA3236@oracle.com>
In-Reply-To: <20100401091808.GA3236@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004011134.15175.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using ignore_loglevel shouldn't affect the problem, so I'm confused.
Can you reproduce the original problem and attach the entire serial
console log?
