Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788Ab2CNDPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 23:15:47 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:56736 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab2CNDPq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 23:15:46 -0400
MIME-Version: 1.0
Date: Tue, 13 Mar 2012 23:15:45 -0400
Message-ID: <CAMgWh9teUdxZChMYqpi98r9VCD=OqFZ+t7hb4hgYiCeC2r3YQA@mail.gmail.com>
Subject: Re: [INFO] : Hibernation and Resume between 2 similar devices
From: David Feuer <david.feuer@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am just curious to know if it is possible to "Hibernate in one device" and "Resume the hibernated image from another similar device".

This is a fairly terrible idea, for various reasons. It might be
better for you to raise this question elsewhere, with basic info like
/why you want to do this/, but my vague guess is that whatever you're
trying to do, you might want to try doing it with virtualization
software (Virtualbox, Xen, KVM, VMWare, etc.) that is actually
designed for doing vaguely similar things. My recollection is that Xen
is specifically optimized to allow for nearly-seamless migration, so
if you actually need this sort of thing (on a phone? a laptop?
whyyyyyyy?) you might try that.

David Feuer
