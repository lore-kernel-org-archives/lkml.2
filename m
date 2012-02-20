Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab2BTTCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 14:02:16 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:51028 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620Ab2BTTCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 14:02:15 -0500
Date: Mon, 20 Feb 2012 11:01:16 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Stephane Eranian <eranian@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@samba.org>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, gleb@redhat.com,
        wcohen@redhat.com, vince@deater.net, asharma@fb.com,
        andi@firstfloor.org, paulus@samba.org, emunson@mgebm.net,
        imunsie@au1.ibm.com, Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [PATCH] perf_events: fix broken intr throttling (v3)
Message-ID: <20120220190116.GA15757@us.ibm.com>
References: <20120126160319.GA5655@quad>
 <20120208223250.282861cb@kryten>
 <CABPqkBRbvs3rHoCw9najObgUvfSCziVrR-U-UARWN3+St2=v8A@mail.gmail.com>
 <20120210031930.GA28023@us.ibm.com>
 <1328854519.3019.3.camel@pasglop>
 <20120215023705.GA13042@us.ibm.com>
 <CABPqkBQD0F4QgZaiEXhyGX-CCbPG74jGu+RPmEOk7HcUGT00cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQD0F4QgZaiEXhyGX-CCbPG74jGu+RPmEOk7HcUGT00cA@mail.gmail.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022019-8974-0000-0000-000006817DB4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian [eranian@google.com] wrote:
| Did Anton recent fix solve that problem?

Yes - could not reproduce on -rc4.

