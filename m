Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab0J1CLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 22:11:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55185 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932457Ab0J1CLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 22:11:41 -0400
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=Ct3xGMI9fAcA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=hzLA2Ban8QssyhtibEgA:9 a=E0d3uPj71aS0FXnFTbMvROsHNlcA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/2] move arch_init_ideal_nop5 later
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu,
        mathieu.desnoyers@polymtl.ca, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com,
        ddaney@caviumnetworks.com, dsd@laptop.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <e35a5b13-ea12-42d2-b569-ff1d69ef58d1@email.android.com>
References: <cover.1288212485.git.jbaron@redhat.com>
	 <2de96f2012e81597079ab0b09a1487e7061b9cc6.1288212486.git.jbaron@redhat.com>
	 <e35a5b13-ea12-42d2-b569-ff1d69ef58d1@email.android.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 27 Oct 2010 22:11:37 -0400
Message-ID: <1288231897.18238.133.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-27 at 15:24 -0700, H. Peter Anvin wrote:
> The exception test is broken anyway for reasons I already explained, so it would be better to just drop it.
> 

Would you be OK if we nuke it for the next merge window? It's been in
there since 2.6.28, I'd hate to drop it now to discover that it breaks
something this late in the merge window.

-- Steve


