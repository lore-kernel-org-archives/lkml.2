Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966690Ab2EOUFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 16:05:47 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:40976 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966025Ab2EOUFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 16:05:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo48ES5iLDCh1WzmHezSEYhPjhtgD5uxoY-TCTKgUBab2g@mail.gmail.com>
References: <20120511222148.30496.68571.stgit@bling.home> <20120511225602.30496.80438.stgit@bling.home>
 <CAErSpo58hKPFb5duOi64sWuR5AJDTVp0rRHkQLotYE3CMXRRhA@mail.gmail.com>
 <1337035766.6954.74.camel@bling.home> <CAErSpo48ES5iLDCh1WzmHezSEYhPjhtgD5uxoY-TCTKgUBab2g@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 15 May 2012 14:05:23 -0600
Message-ID: <CAErSpo4LSSfBNj7dDZ1B5aR=teNkRFHvyibRmNsSmZ03dt5xPw@mail.gmail.com>
Subject: Re: [PATCH 05/13] pci: New pci_acs_enabled()
To: Alex Williamson <alex.williamson@redhat.com>
Cc: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org, chrisw@sous-sol.org,
        agraf@suse.de, benve@cisco.com, aafabbri@cisco.com,
        B08248@freescale.com, B07421@freescale.com, avi@redhat.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I tried to work through some examples to develop some intuition about this:

Sorry, gmail inserted line breaks that ruined this picture.  Here's a
URL for it:

http://www.asciiflow.com/#3736558963405980039
