Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab2AWRqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 12:46:48 -0500
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:51395 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751653Ab2AWRqr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 12:46:47 -0500
X-AuditID: 1209190e-b7f7c6d0000008c3-3b-4f1d9d063e55
Subject: Re: /etc/fstab.d yes or not
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <CAPXgP11pvch92n1=mMfDsMLoGZMG8xq0e1juXyUO6mxFR6_GYg@mail.gmail.com>
Date: Mon, 23 Jan 2012 08:55:21 -0500
Cc: Theodore Tso <tytso@MIT.EDU>, Roger Leigh <rleigh@codelibre.net>,
        Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, util-linux@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <ACD4236E-A309-465F-8789-DA3A5B648313@mit.edu>
References: <20120120140444.GC13157@x2.net.home> <20120120154912.GK8797@codelibre.net> <CAPXgP13a9v+f1uNdpe-c+aApLfLpgn15b1-gZxRPd0wMvU=B-Q@mail.gmail.com> <20120120162220.GN8797@codelibre.net> <CAPXgP11pvch92n1=mMfDsMLoGZMG8xq0e1juXyUO6mxFR6_GYg@mail.gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
X-Mailer: Apple Mail (2.1251.1)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsUixG6noss2V9bfoHmHrMXlDefYLJYu2cFm
	sWfvSRaLy7vmsFmcfLKL3WLOlRZ2BzaPd9emMHq833eVzePzJjmPj+s9A1iiuGxSUnMyy1KL
	9O0SuDL+Pz/EWDCPueLz5TPsDYwHmboYOTkkBEwkZk2bzAJhi0lcuLeerYuRi0NIYB+jRM/C
	BUwQzgZGiVU3vrCDVAkJHGeSWLxOBsQWFlCRuDenjxXE5hUwllhz6x3YJGYBLYkb/16CbWAT
	UJK482k/WJxTIFBixvvrYHEWAVWJ88fmMoMsYBY4wyjx/MhjZohmbYllC18zQwy1kri1aTs7
	xBVtTBKvzjwFu0JEQE1iwf71UD/IS7R8vcM2gVFwFpJDZiE5ZBaSuQsYmVcxyqbkVunmJmbm
	FKcm6xYnJ+blpRbpGuvlZpbopaaUbmIEBT+nJN8Oxq8HlQ4xCnAwKvHwHpgm6y/EmlhWXJl7
	iFGSg0lJlHfFbKAQX1J+SmVGYnFGfFFpTmrxIUYJDmYlEV6jxzL+QrwpiZVVqUX5MClpDhYl
	cV41rXd+QgLpiSWp2ampBalFMFkZDg4lCd7Zc4CGChalpqdWpGXmlCCkmTg4QYbzAA1fClLD
	W1yQmFucmQ6RP8Woy/Hld9t5RiGWvPy8VClx3n6QIgGQoozSPLg5sKT1ilEc6C1h3l0gVTzA
	hAc36RXQEiagJRx5UiBLShIRUlINjOWn/r0/LLKocs2W1ZUPbs59fH0R55sepgO3fsmmPqxa
	9veMz3KJZ8dSD63y3mw2dXXt2V2HxUPvb3Yw1Z9y+Mj7E5xnzjqEaeltfP3JQFBa+ld83Cql
	XNvylibuCQtEljIVW8wPjsxdm/Xq9a/4F9afXp/ks2tTVziWIRPocGlpsuNK2+vbJ6oqsRRn
	JBpqMRcVJwIAct9mfzUDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am extremely dubious about systemd, and would much rather it not be on any system that *I* run (and using UUID's to identify kernel notification is just whacko) , but I have to agree with Kay in that /etc/fstab.d is Just Wrong.   The /etc/fstab file is parsed by many programs, shell scripts, and not just the ones in util-linux.   We should consider it an ABI, and not mess with it.

-- Ted

