Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab1EXNGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:06:33 -0400
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:42079 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755236Ab1EXNGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:06:31 -0400
X-AuditID: 12074423-b7babae000007c6b-52-4ddbad573a76
Subject: Re: UNIX Compatibility
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <BANLkTin4wu1HNDeo8Rv7iddM9KkgZdhfgA@mail.gmail.com>
Date: Tue, 24 May 2011 09:06:28 -0400
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <A7E21A2F-4338-465D-933A-66B0C4D15BE1@mit.edu>
References: <BANLkTin4wu1HNDeo8Rv7iddM9KkgZdhfgA@mail.gmail.com>
To: Richard Yao <ryao@ic.sunysb.edu>
X-Mailer: Apple Mail (2.1084)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsUixCmqrBu+9ravwbtVhhaXd81hs/jYpuzA
	5DH14nsmj8+b5AKYorhsUlJzMstSi/TtErgy7h/9xl5wj73i3//PTA2Mk9i6GDk5JARMJJ49
	OMQEYYtJXLi3HiwuJLCPUWJDk0YXIxeQvYFR4uuRE8wQzmkmifNdE1lBqoQF5CVmz/oAZvMK
	GEos3dTODmIzC2hJ3Pj3Emwqm4CSxJ1P+1lAbE4BR4mGV1PBbBYBVYl7f+4zQtQrSPy6t4kV
	wpaX2P52DjPETCuJed9us0Nc5CCxd+s6sBoRARWJK0+bgWwOoKtlJZqWZUxgFJyF5IpZSK6Y
	hWTqAkbmVYyyKblVurmJmTnFqcm6xcmJeXmpRbpmermZJXqpKaWbGEGhy+6ivIPxz0GlQ4wC
	HIxKPLxe02/5CrEmlhVX5h5ilORgUhLlXbnmtq8QX1J+SmVGYnFGfFFpTmrxIUYJDmYlEd4V
	WUA53pTEyqrUonyYlDQHi5I471xJdV8hgfTEktTs1NSC1CKYrAwHh5IE7xaQoYJFqempFWmZ
	OSUIaSYOTpDhPEDDk0FqeIsLEnOLM9Mh8qcYFaXEedeDJARAEhmleXC9sNTyilEc6BVh3j6Q
	Kh5gWoLrfgU0mAlosMTfmyCDSxIRUlINjLsDRO9t443lsCjyl29UKjWdOF1ukRlra10Qw01D
	0bUbGs88PL6ptrlj2wRWpjmqdy0L9tiXzF4UejvxPVfcMrH9N9cKPLl4xWP7rIMSYRx8zhNP
	WLQeELh+RdXFSa9y7UKHYNXzAuna5Xn3Ttn/MUtZ06qhFisTXxn6PtxzuhVTkef2HqVlSizF
	GYmGWsxFxYkAb8Z+VwgDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 24, 2011, at 7:49 AM, Richard Yao wrote:

> I know that the system call codes used by Linux are not 100% UNIX
> compatible. Is there anything else in the kernel that is not UNIX
> compatible? Would modifying these things for UNIX compatibility break
> anything in userland provided that it is recompiled against the
> modified sources?

What do you mean by "UNIX compatible?"  API compatibility?
ABI compatibility?   Which Unix?  Solaris and HPUX and AIX
are systems which are allowed to use the Unix(tm) trademark,
but them are not compatible with each other.

So the question you are asking is not well defined.

Also, why are you asking it?   What problem are you trying to solve?
At this point, Linux is running on far more servers than any of the
Legacy Unix systems out there, and the ones which are still in
development (i.e., Solaris and AIX) are have recently been worrying
about adding Linux compatibility layers (usually at the API level).

-- Ted

