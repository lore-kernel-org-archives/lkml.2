Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362Ab1CCPbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 10:31:48 -0500
Received: from flanders.hackvalue.nl ([82.94.238.226]:50044 "EHLO
	flanders.hackvalue.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036Ab1CCPbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 10:31:46 -0500
X-Greylist: delayed 2142 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Mar 2011 10:31:46 EST
Subject: changing EXPORT_SYMBOL_GPL to EXPORT_SYMBOL in DD-WRT
From: Armijn Hemel <armijn@gpl-violations.org>
To: s.gottschall@newmedia-net.de
Cc: laforge@gpl-violations.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 15:55:59 +0100
Message-ID: <1299164159.10725.19.camel@hibbert>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello Sebastian,

I noticed that a few hours ago you changed a few lines in the kernel
source of DD-WRT, changing the export from a few symbols from 'GPL only'
to something a lot more permissive:

http://svn.dd-wrt.com:8000/changeset/16368

As you are probably aware the EXPORT_SYMBOL_GPL macro is there to
clearly signal that it was the author's intent to make these symbols
only available to GPL licensed kernel modules. What you have effectively
done is ignore the author's intent. It also might end up in DD-WRT
derivatives.

I am sure that this is not what you meant to do. The commit message
indicates that you are working around a certain problem you are facing
with DD-WRT. I am sure that the Linux kernel developers would love to
hear about that problem. For your convenience I have put them in CC.

warm regards,

armijn

-- 
 ---------------------------------------------------------------------------
        armijn@gpl-violations.org || http://www.gpl-violations.org/
 ---------------------------------------------------------------------------

