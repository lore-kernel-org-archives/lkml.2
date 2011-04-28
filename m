Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab1D1DlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 23:41:11 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34269 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab1D1DlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 23:41:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=j352+FfoABpn8qvgWYiPqQ/epSUD8oabNBWti2uZNsQOdQ0kSP1EKnq+3EUoIXGvPH
         j08xNjkT6cknD8oC4/vpZ0aIQYrlAbzsiPIRkCeP5E1Q+iFG0VbD2tLCPj8+rHouVpn/
         Nzjy+2+HLsWv5JQj6WE1kD+UkmZnS7Dv8UZUc=
MIME-Version: 1.0
Date: Thu, 28 Apr 2011 11:41:07 +0800
Message-ID: <BANLkTimFnZTHnnJ_UN82fw5x2-9-icJCuw@mail.gmail.com>
Subject: where to set framebuffer page read-only,when using differred IO?
From: april <aapril03@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all:
I'm writing a driver, and want to catch the cpu write and just flush
page that cpu write before device engine access.
may be some thing like differred IO.
I read the differred IO and fb 's code, I can't found where it set the
page table entries for framebuffer pages to read-only.

Could anyone help to show where the frame buffer page set to read-only?

Thanks in advance
Aapril
