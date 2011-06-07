Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab1FGNgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 09:36:47 -0400
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:50096 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753747Ab1FGNgp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 09:36:45 -0400
X-AuditID: 1209190f-b7b0eae000000a42-9f-4dee29714a30
Subject: Re: XFS problem in 2.6.32
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <4DEE1D96.6020208@profihost.ag>
Date: Tue, 7 Jun 2011 09:36:41 -0400
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <6D8DA3D2-D90B-4D82-BDC9-C3F0264A68BF@mit.edu>
References: <4DEE1D96.6020208@profihost.ag>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
X-Mailer: Apple Mail (2.1084)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsUixG6nrluo+c7X4P9ra4vLu+awWeyZv4Xd
	gcnjQ+dLRo/Pm+QCmKK4bFJSczLLUov07RK4MmbcesBWcImt4n/vI8YGxtWsXYycHBICJhJ3
	985igrDFJC7cW8/WxcjFISSwj1Hifd9OdghnPaPElRfLoDKnmCQ+nbgL1iIsoCTROu8vI4jN
	K2AosXRTOzuIzSygJXHj30uwGjagmjuf9rOA2JwCOhJHJx4Hq2cRUJE4seAkC0S9gsSve5tY
	IWxtiWULXzNDzLSSuHBnL9gcIaD4jp/v2EBsEQELiR17FgPZHEBny0o0LcuYwCg4C8kVs5Bc
	MQvJ1AWMzKsYZVNyq3RzEzNzilOTdYuTE/PyUot0TfRyM0v0UlNKNzGCwpdTkn8H47eDSocY
	BTgYlXh4X3954yvEmlhWXJl7iFGSg0lJlDdV452vEF9SfkplRmJxRnxRaU5q8SFGCQ5mJRHe
	Gdff+grxpiRWVqUW5cOkpDlYlMR5Z0mq+woJpCeWpGanphakFsFkZTg4lCR4H4EMFSxKTU+t
	SMvMKUFIM3FwggznARq+DKSGt7ggMbc4Mx0if4pRUUqcdxpIQgAkkVGaB9cLSy+vGMWBXhHm
	vQJSxQNMTXDdr4AGMwENPn0W5OrikkSElFQDo2n+DPXFU//Ilmswchgb3mdOl1x1l/HkmqSd
	lc9LkzQrVG+JPxVIdGK8ufPp42ltrOxnfm9k1IySf/NDWHj1/1aGO9/tJdNTO0Q4d918Ijhx
	TfhnqS4ullnSrauezDPtyt300bTg15HHTPv1GSv9b/x/w/ZYTubsZqHen355/6wTzmzqjNx7
	RYmlOCPRUIu5qDgRAP13q6sKAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 7, 2011, at 8:46 AM, Stefan Priebe - Profihost AG wrote:

> Hi List,
> 
> i've massive problems with a machine using 2.6.32 kernel and XFS: I've desribed the problem here:
> http://www.spinics.net/lists/xfs/msg04984.html
> 
> The reply on the XFS mailinglist was:
> http://www.spinics.net/lists/xfs/msg04994.html
> 
> So who keeps track on which patches needs to get backported or not? And who will backport XFS fixes back to 2.6.32?

An interested kernel developer.   They can become interested because they personally have the time or interest, or because someone pays them to become interested.  Support of the stable kernel series is not something that happens magically, or which is funded by a charity, you know.  That's why some companies pay $$$ for a supported distribution kernel.

-- Ted

