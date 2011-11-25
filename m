Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab1KYKUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 05:20:51 -0500
Received: from imailer.gwdg.de ([134.76.11.19]:37775 "EHLO imailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563Ab1KYKUu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 05:20:50 -0500
X-Greylist: delayed 2311 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Nov 2011 05:20:49 EST
From: "Esztermann, Ansgar" <Ansgar.Esztermann@mpi-bpc.mpg.de>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 25 Nov 2011 10:42:15 +0100
Subject: TCP fast retransmit
Thread-Topic: TCP fast retransmit
Thread-Index: AcyrVoRLqBG3odrMQwmsWxvPg4Yoiw==
Message-ID: <A07B21E9-038F-49AB-A327-3E85BD45193D@mpi-bpc.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
 _SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

is there some documentation available on TCP fast retransmit? There seem to be quite a lot of descriptions -- from informal to scholarly papers -- on the various algorithms available to calculate the proper size of the congestion window, but I have been unable so far to find out *when* a fast retransmit is triggered. RFC 2581 states the third dupACK "should" do it, and this seems to be quoted fairly often. However, I can easily produce connections that fail to perform fast retransmit even after 5 dupACKs. Some people mention Linux uses a different (presumable more sophisticated) algorithm to trigger fast retransmits, but no-one seems to elaborate.


Thanks,

A.
-- 
Ansgar Esztermann
DV-Systemadministration
Max-Planck-Institut für biophysikalische Chemie, Abteilung 105

