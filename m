Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab2JWOt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 10:49:26 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:28787 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab2JWOtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 10:49:24 -0400
X-AuditID: cbfee61b-b7f616d00000319b-dd-5086ae35805e
From: Kukjin Kim <kgene@kernel.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: ERROR: "read_current_timer" [fs/ext4/ext4.ko] undefined
Date: Tue, 23 Oct 2012 23:48:21 +0900
Message-id: <022101cdb12d$724e9650$56ebc2f0$@org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2xLXI3P/C3hqMMT7KUlEjoOAoFEw==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zY13TdW0BBle7FSwu75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDJa961lLdjLVPFj8U6WBsZmpi5GTg4JAROJSf1/mSFs
	MYkL99azgdhCAssYJabu1oKpWfLiKVCcCyg+nVHi0eqNjBDOX0aJfbtfsXYxcnCwCShLNDbp
	gzQIC2hJLNzSxAJiiwhkS/z4NpkFIu4gcbd9EdgCFgFViQW79oDFeQUMJTomrWKFsAUlfky+
	BxZnBpqzfudxJghbXmLzmrfMIKskBNQlHv3VhRivJ/H35Ep2iBIRiX0v3jFCjBeQ+Db5EAtE
	uazEpgPMIBdLCHSzS3R8+sUK8ZekxMEVN1gmMIrNQrJ5FpLNs5BsnoVkxQJGllWMoqkFyQXF
	Sem5RnrFibnFpXnpesn5uZsYIREjvYNxVYPFIUYBDkYlHt6O/a0BQqyJZcWVuYcYJTiYlUR4
	Te3bAoR4UxIrq1KL8uOLSnNSiw8x+gBdPpFZSjQ5HxjNeSXxhsbGJmYmpibmlqbmpjiElcR5
	mz1SAoQE0hNLUrNTUwtSi2DGMXFwSjUwqu1YUMKSX5fKMfXZRfaj2t81ClNMZuZs+nLu2vyi
	3/UxfQ+UZqVNXvPyePeUF98TL3En6C4W/GbH5KC+OGujuW3jMd+5+d83L7siu+K1wanKpuYK
	txMZt3m27W2oCD+5ic05mn2l4k4xI8WNZn1J9f6adwr/mMUyLJ209e+Z1sU6k365ucyQU2Ip
	zkg01GIuKk4EAH6OwxXFAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t9jQV3TdW0BBpeXylpc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmtO5by1qwl6ni
	x+KdLA2MzUxdjJwcEgImEktePGWDsMUkLtxbD2RzcQgJTGeUeLR6IyOE85dRYt/uV6xdjBwc
	bALKEo1N+iANwgJaEgu3NLGA2CIC2RI/vk1mgYg7SNxtXwQ2lEVAVWLBrj1gcV4BQ4mOSatY
	IWxBiR+T74HFmYHmrN95nAnClpfYvOYtM8gqCQF1iUd/dSHG60n8PbmSHaJERGLfi3eMExgF
	ZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnBEPpPewbiqweIQ
	owAHoxIPb8f+1gAh1sSy4srcQ4wSHMxKIrym9m0BQrwpiZVVqUX58UWlOanFhxh9gB6dyCwl
	mpwPTBZ5JfGGxiZmRpZGZhZGJubmOISVxHmbPVIChATSE0tSs1NTC1KLYMYxcXBKNTBuS3cI
	v9N+OTGURXNr6Q7J+Rd2ed2r8bxTH//2EaORU6oVoytHzArtb6qnTCs0/K85tdSterq/qKh3
	ubTEsZXfPspdk6mpr3C9bOf+rZHV292MKTflkq3i0SWhxYaHHq58ePhW5ql1zu9+BH80V41N
	vblD7Z3E65w6TaVT913O7/Q8FBjZvU6JpTgj0VCLuag4EQBT0N7q9QIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Now, v3.7-rc2 happens following build error with s3c2410_defconfig...

ERROR: "read_current_timer" [fs/ext4/ext4.ko] undefined!
make[2]: *** [__modpost] Error 1
make[1]: *** [modules] Error 2
make[1]: *** Waiting for unfinished jobs....

Any idea on this?

Thanks.

K-Gene <kgene@kernel.org>

