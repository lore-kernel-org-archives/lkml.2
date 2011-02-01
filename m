Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab1BASRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 13:17:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857Ab1BASRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 13:17:23 -0500
Subject: Re: [PATCH] System Wide Capability Bounding Set
From: Eric Paris <eparis@redhat.com>
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: Steve Grubb <sgrubb@redhat.com>, "Andrew G. Morgan" <morgan@kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Date: Tue, 01 Feb 2011 13:17:00 -0500
In-Reply-To: <20110128193809.GB8854@localhost>
References: <1294266337.3237.45.camel@localhost.localdomain>
	 <201101270942.07689.sgrubb@redhat.com> <20110128184901.GA5134@localhost>
	 <201101281410.29794.sgrubb@redhat.com> <20110128193809.GB8854@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1296584221.3145.12.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What are we thinking?  Any suggestions how to do what we need other than

global bounding such that  pP' = gbset & (fI | pI)

Or an interface in which I can force things out of the bset and pI of
other tasks?  Possibly the interface could be specific to the "khelper"
thread?

-Eric

