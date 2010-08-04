Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429Ab0HDW5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 18:57:14 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44906 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab0HDW5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 18:57:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=XnhsYnFmsZldu250jLJCKL77ey+l7c/+GTABBVQAFEriFv8UkIe4F27wywTNIABQhS
         P53AF+d7Nbq2+aW/eDh16jxcrfG+ge3xssPywvm6xT36y4HbffDUn89QJWGqFq2JodtP
         4M7Boc9PZVEI+Xl65LoHxzZ3Kyk1M6eVGoudI=
MIME-Version: 1.0
Date: Wed, 4 Aug 2010 15:57:12 -0700
Message-ID: <AANLkTimC6bsX7vDc8XNqPm3XB_YmpgM3BsNDHewaO20P@mail.gmail.com>
Subject: PCI MSI/MSI-X interrupts support in 2.4.x kernel?
From: Sanjay Gandotra <sanhay@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
My appliance is running on linux kernel 2.4.21 which does not support
PCI MSI/MSI-X interrupts. I was wondering if there is any patch
available on 2.4.x kernels to support PCI MSI/MSI-X interrupts or else
my option is to upgrade the kernel?
Thanks,
Sanjay
