Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935092Ab0GPAWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 20:22:04 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63072 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934560Ab0GPAWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 20:22:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=mjfEADBONeVrSLlUjX8bzDPtV/DTw+ZRm0xlK5QO38nwr9HG4LEksbmvxQoR15xklM
         eD3Aemm7RhEyOy+DPkVI1tW5paAont9B2+E4tO3kXXeJcaH/+ZNrPMM4jnO+bM0Q73xx
         b/i7XfSMR7CN3LmKeCTOKI9f8DIwIYyVNcXB8=
MIME-Version: 1.0
Date: Fri, 16 Jul 2010 02:22:00 +0200
Message-ID: <AANLkTilYvcZknlMMJA6e3ei2KPpodZxEvjjNlHVRcV8s@mail.gmail.com>
Subject: simulating errors in the file system
From: Jan III Sobieski <jan3sobi3ski@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would like to test the behavior of my library in the event of a
fault. I wonder if it is possible to simulate errors in Linux
filesystem?

I heard once about a file system designed for such tests, but
unfortunately I do not remember it's name.

Could you give me a link to the documentation that describes how to
perform such tests on Linux filesystem?

-- 
Jan III Sobieski
