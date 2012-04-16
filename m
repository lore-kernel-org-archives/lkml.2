Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab2DPP0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:26:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33600 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab2DPP0X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:26:23 -0400
Message-ID: <1334589962.28150.69.camel@twins>
Subject: Re: [RFCv2 0/8] perf tool: Add new event group management
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org
Date: Mon, 16 Apr 2012 17:26:02 +0200
In-Reply-To: <20120416121627.GA1660@m.brq.redhat.com>
References: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
	 <1334503015.28150.16.camel@twins> <20120416121627.GA1660@m.brq.redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-16 at 14:16 +0200, Jiri Olsa wrote:
> group:        group_spec '{' events '}'
> group_spec:   name  ':' mod | empty 

How about something like:

groups: groups ',' group | group
group:	group_name '{' events '}' group_mod
group_name: name ':' | empty
group_mod: ':' group_mods | empty
group_mods: [l]


