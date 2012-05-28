Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab2E1LjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 07:39:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57264 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab2E1LjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 07:39:13 -0400
Date: Mon, 28 May 2012 13:39:03 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE][PATCH 5/26]Rotary Interactivity Favor Scheduler
 Version 3(Brain-Eating) Update.
Message-ID: <20120528113903.GA5187@fancy-poultry.org>
References: <CANQmPXhyAavikU=861nVA3WjPsMjBt+XOTUJ08VAoinZ1gCRzQ@mail.gmail.com>
 <CAJd=RBDN7q0C+ktY29B66d9coyy1BGESOHCHFmFQVboOfNXq5w@mail.gmail.com>
 <CANQmPXi+O-bHFzbi1q5g0GuKgXmeyEYp+UB_61YDDd2uE475GA@mail.gmail.com>
 <CANQmPXipw9QPEc9xMuCLDW14W3w5VeUYZP1GJnvR+D57xCWksA@mail.gmail.com>
 <CAJd=RBC5=JHEUD7N4cQc87AkkgYc-VS+TBEza6QMomA1DsOL1g@mail.gmail.com>
 <CANQmPXhpV1Hq11FM4vwN7yneGQ7F7wC0Mh+zGCPgNgxry8xLqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANQmPXhpV1Hq11FM4vwN7yneGQ7F7wC0Mh+zGCPgNgxry8xLqg@mail.gmail.com>
Organization: private site
X-OpenPGP-KeyID: 0x898F89DE
X-OpenPGP-Fingerprint: 0815 20AD E896 A2B7 488F  4659 4C7B 8951 898F 89DE
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+54 (41a8d7dceb6c) (2011-07-01)
X-Provags-ID: V02:K0:xzJyRovG9Sq0r9kTOo0kFN/rZQeE0kcWIHHrOzgxibz
 yEOd9AGIDMqCMJWFH5CWxkPb0aANCvd09qPis59gnwQw+WnTEw
 hYiYYpbat39SagZ9cqYvSfRtRTJ6AOs+tzuOuVXZKxpg2o7483
 PWkDjpIj9S08mwu9qd5WGMhinWvExJx5xNzDjXJnZ0zqTz4u+S
 +61RpvdiQS9y7agO9LZLWvuUNUK9tAIwbh9M1Z8Y7Og9nve66x
 wkTLDA1lQM+wZBsXuneoyDivufmLTe/PxuSbk3Gq3bQPVWqC/B
 7eNv943sJcXfvYZIIGQYrswIV9rPR0s6SFZVrVw0xElRboK4WJ
 ivN8UnHZhzjTv/gsedA/lANsoENiL6F0InsDRIZ4c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.05.2012, Chen wrote: 

> This is the patch

What you posted is a patch on the BFS-4.20 patch (by Con Kolivas)
itself, and not a patch against an actual kernel tree. The output 
has a format which is totally unreadable and disgusting, 
and I can't apply it without tinkering with BFS first,
(which is designed for 3.3.x and needs a merge into 3.4.0 on top of that)

Could you please provide a clean patch which is based on one of the
current trees?

Besides, it seems to me that you are trying to reinvent the wheel
using a lot of pieces of Con's -ck patch..

Thanks,
Heinz.
