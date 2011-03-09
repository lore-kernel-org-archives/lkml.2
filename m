Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396Ab1CIMzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 07:55:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54006 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab1CIMy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 07:54:58 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=FKmPEgYRmMMA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=to2kARTYHKiZ5jZ8DlQA:9 a=V-6HzLkyteLQ6UshBkLzrN_sTkgA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 07/15] ftrace: fix event alignment: kvm:kvm_hv_hypercall
From: Steven Rostedt <rostedt@goodmis.org>
To: Avi Kivity <avi@redhat.com>
Cc: David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        mrubin@google.com, kvm-devel <kvm@vger.kernel.org>
In-Reply-To: <4D773F3D.7080503@redhat.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
	 <1291421609-14665-8-git-send-email-dhsharp@google.com>
	 <4CF9F7AB.8050802@redhat.com>
	 <AANLkTi=H9eSAOKmN8KdKDKiFZdD7DjQC=wa+fqrDpe2q@mail.gmail.com>
	 <4CFDFCEF.3080708@redhat.com>
	 <AANLkTinK7Zqh=GfFLeyJLxA4u2ozyVj-Ja435iBJPV13@mail.gmail.com>
	 <4CFF4D4C.2070002@redhat.com>
	 <1299628541.20306.99.camel@gandalf.stny.rr.com>
	 <4D773F3D.7080503@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 09 Mar 2011 07:54:55 -0500
Message-ID: <1299675295.15854.3.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 10:50 +0200, Avi Kivity wrote:
> On 03/09/2011 01:55 AM, Steven Rostedt wrote:
> > Hi Avi,
> >
> > This patch set got lost in the shuffle, and I'm not looking to include

Nasty typo:  s/not/now/

> > it.
> 
> Anything I need to do?
> 

Yeah, give me your Acked-by ;)

-- Steve



