Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933670Ab1JZRXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 13:23:35 -0400
Received: from smtp-out.google.com ([216.239.44.51]:35884 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933408Ab1JZRXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 13:23:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:from:date:message-id:subject:to:cc:
	content-type:x-system-of-record;
	b=qnR89v1E27BA1tJUEKbobLejj36yUXI1HbbSRkwuUib0dUb8jsWeUQEKqnUuJqhqV
	bTKsBn/d5a6+lUaRM76ZQ==
MIME-Version: 1.0
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 26 Oct 2011 11:23:11 -0600
Message-ID: <CAErSpo4REhcp_SgDyUTbi8jw9_8317Zi1duo1fTihB8x=drtuw@mail.gmail.com>
Subject: regression tracking
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regression tracking that you folks used to do before the demise of
bugzilla.kernel.org was incredibly valuable.

I'm very concerned about the fact that we don't have a systematic way
to do this any more.  Some things do get reported on LKML, of course,
but without the legwork you guys did, I'm afraid we're just dropping
things on the floor because there's no summary of what the issues are,
how many people are seeing them, who's responsible, etc.

Consider this as (1) kudos for performing an essential community
service, and (2) a plea for the resurrection or replacement of
bugzilla.kernel.org or some other mechanism for reviving regression
tracking.

Bjorn
