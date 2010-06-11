Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075Ab0FKCzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 22:55:19 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54382 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab0FKCzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 22:55:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=nQ0Y+paKLlS98TrK2eBpYZoAGrcLNNzhISjlroK78JUt+SIhARS3pLmS28TKI4qHqS
         qOy+aZxUxUG7bQ5hzTwoLYRQXjXv0qteJds9N5qXU4A2alc+CUnR6xivuP1o0Vi32nQf
         /epsDRWpn4LfbIET99L5Q7hBILHgCL7j9AkGk=
Message-ID: <4C11A598.8090504@gmail.com>
Date: Thu, 10 Jun 2010 19:55:20 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andi Kleen <andi@firstfloor.org>
Subject: warning from gcc version 4.6.0 20100416
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o.k. andi,

here is the rest of the warnings that
I see when compiling the kernel

I can try and create some patches for
this(hopefully!!)


it's a bit long so hopefully it goes through


                              make menuconfig


  HOSTCC  scripts/basic/fixdep
   HOSTCC  scripts/basic/docproc
   HOSTCC  scripts/basic/hash
   HOSTCC  scripts/kconfig/conf.o
scripts/kconfig/conf.c: In function 'conf_sym':
scripts/kconfig/conf.c:159:6: warning: variable 'type' set but not used
scripts/kconfig/conf.c: In function 'conf_choice':
scripts/kconfig/conf.c:231:6: warning: variable 'type' set but not used
   HOSTCC  scripts/kconfig/kxgettext.o
   HOSTCC  scripts/kconfig/lxdialog/checklist.o
scripts/kconfig/lxdialog/checklist.c: In function 'print_item':
scripts/kconfig/lxdialog/checklist.c:36:2: warning: value computed is 
not used
scripts/kconfig/lxdialog/checklist.c:42:2: warning: value computed is 
not used
scripts/kconfig/lxdialog/checklist.c:47:2: warning: value computed is 
not used
scripts/kconfig/lxdialog/checklist.c:49:2: warning: value computed is 
not used
scripts/kconfig/lxdialog/checklist.c: In function 'print_arrows':
scripts/kconfig/lxdialog/checklist.c:66:3: warning: value computed is 
not used
scripts/kconfig/lxdialog/checklist.c:70:3: warning: value computed is 
not used
scripts/kconfig/lxdialog/checklist.c:81:3: warning: value computed is 
not used
scripts/kconfig/lxdialog/checklist.c:85:3: warning: value computed is 
not used
scripts/kconfig/lxdialog/checklist.c: In function 'dialog_checklist':
scripts/kconfig/lxdialog/checklist.c:148:2: warning: value computed is 
not used
scripts/kconfig/lxdialog/checklist.c:152:2: warning: value computed is 
not used
scripts/kconfig/lxdialog/textbox.c: In function 'dialog_textbox':
scripts/kconfig/lxdialog/textbox.c:98:2: warning: value computed is not used
scripts/kconfig/lxdialog/textbox.c:107:2: warning: value computed is not 
used
scripts/kconfig/lxdialog/textbox.c:111:2: warning: value computed is not 
used
scripts/kconfig/lxdialog/textbox.c: In function 'print_line':
scripts/kconfig/lxdialog/textbox.c:323:9: warning: variable 'x' set but 
not used
scripts/kconfig/lxdialog/textbox.c:323:6: warning: variable 'y' set but 
not used
scripts/kconfig/lxdialog/textbox.c: In function 'print_position':
scripts/kconfig/lxdialog/textbox.c:386:2: warning: value computed is not 
used
   HOSTCC  scripts/kconfig/lxdialog/util.o
scripts/kconfig/lxdialog/util.c: In function 'attr_clear':
scripts/kconfig/lxdialog/util.c:243:2: warning: value computed is not used
scripts/kconfig/lxdialog/util.c: In function 'dialog_clear':
scripts/kconfig/lxdialog/util.c:259:3: warning: value computed is not used
scripts/kconfig/lxdialog/util.c: In function 'print_title':
scripts/kconfig/lxdialog/util.c:316:3: warning: value computed is not used
scripts/kconfig/lxdialog/util.c: In function 'print_button':
scripts/kconfig/lxdialog/util.c:396:2: warning: value computed is not used
scripts/kconfig/lxdialog/util.c:401:2: warning: value computed is not used
scripts/kconfig/lxdialog/util.c:405:2: warning: value computed is not used
scripts/kconfig/lxdialog/util.c:408:2: warning: value computed is not used
scripts/kconfig/lxdialog/util.c:411:2: warning: value computed is not used
scripts/kconfig/lxdialog/util.c: In function 'draw_box':
scripts/kconfig/lxdialog/util.c:426:2: warning: value computed is not used
scripts/kconfig/lxdialog/util.c: In function 'draw_shadow':
scripts/kconfig/lxdialog/util.c:460:3: warning: value computed is not used
   HOSTCC  scripts/kconfig/lxdialog/yesno.o
scripts/kconfig/lxdialog/yesno.c: In function 'dialog_yesno':
scripts/kconfig/lxdialog/yesno.c:64:2: warning: value computed is not used
scripts/kconfig/lxdialog/yesno.c:68:2: warning: value computed is not used
scripts/kconfig/lxdialog/yesno.c:73:2: warning: value computed is not used
   HOSTCC  scripts/kconfig/mconf.o
   HOSTCC  scripts/kconfig/zconf.tab.o
   HOSTLD  scripts/kconfig/mconf



                           make



   CC      init/main.o
init/main.c: In function 'do_one_initcall':
init/main.c:724:10: warning: 'calltime.tv64' may be used uninitialized 
in this function
   CHK     include/generated/compile.h

   CC      arch/x86/kernel/process.o
arch/x86/kernel/process.c: In function 'c1e_idle':
arch/x86/kernel/process.c:584:11: warning: variable 'hi' set but not used
   CC      arch/x86/kernel/i387.o

   CC      arch/x86/kernel/apic/apic.o
arch/x86/kernel/apic/apic.c: In function 'lapic_suspend':
arch/x86/kernel/apic/apic.c:2014:3: warning: statement with no effect
arch/x86/kernel/apic/apic.c: In function 'lapic_resume':
arch/x86/kernel/apic/apic.c:2091:3: warning: statement with no effect
   CC      arch/x86/kernel/apic/apic_noop.o

   CC      arch/x86/kernel/cpu/intel.o
arch/x86/kernel/cpu/intel.c: In function 'early_init_intel':
arch/x86/kernel/cpu/intel.c:58:14: warning: variable 'junk' set but not used
arch/x86/kernel/cpu/intel.c: In function 'init_intel':
arch/x86/kernel/cpu/intel.c:354:15: warning: variable 'l2' set but not used
   CC      arch/x86/kernel/cpu/amd.o
   CC      arch/x86/kernel/cpu/centaur.o
   CC      arch/x86/kernel/cpu/perf_event.o
In file included from arch/x86/kernel/cpu/perf_event.c:1248:0:
arch/x86/kernel/cpu/perf_event_p4.c: In function 'p4_pmu_init':
arch/x86/kernel/cpu/perf_event_p4.c:836:20: warning: variable 'high' set 
but not used
   LD      arch/x86/kernel/cpu/cpufreq/built-in.o
   CC [M]  arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.o
arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c: In function 'do_drv_read':
arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c:153:6: warning: variable 'h' 
set but not used
   CC [M]  arch/x86/kernel/cpu/cpufreq/mperf.o
   CC [M]  arch/x86/kernel/cpu/cpufreq/speedstep-lib.o
   CC [M]  arch/x86/kernel/cpu/cpufreq/speedstep-centrino.o
   CC [M]  arch/x86/kernel/cpu/cpufreq/p4-clockmod.o
   CC      arch/x86/kernel/cpu/mcheck/mce.o
   CC      arch/x86/kernel/cpu/mcheck/mce-severity.o
   CC      arch/x86/kernel/cpu/mcheck/mce_intel.o
   CC      arch/x86/kernel/cpu/mcheck/mce_amd.o
arch/x86/kernel/cpu/mcheck/mce_amd.c: In function 
'local_error_count_handler':
arch/x86/kernel/cpu/mcheck/mce_amd.c:325:6: warning: variable 'low' set 
but not used
   CC      arch/x86/kernel/cpu/mcheck/threshold.o
   CC      arch/x86/kernel/cpu/mcheck/therm_throt.o
   LD      arch/x86/kernel/cpu/mcheck/built-in.o
   CC      arch/x86/kernel/cpu/mtrr/main.o
arch/x86/kernel/cpu/mtrr/main.c: In function 'set_num_var_ranges':
arch/x86/kernel/cpu/mtrr/main.c:116:28: warning: variable 'dummy' set 
but not used
   CC      arch/x86/kernel/cpu/mtrr/if.o
   CC      arch/x86/kernel/cpu/mtrr/generic.o
arch/x86/kernel/cpu/mtrr/generic.c: In function 'get_mtrr_state':
arch/x86/kernel/cpu/mtrr/generic.c:310:15: warning: variable 'dummy' set 
but not used
arch/x86/kernel/cpu/mtrr/generic.c: In function 'generic_have_wrcomb':
arch/x86/kernel/cpu/mtrr/generic.c:740:24: warning: variable 'dummy' set 
but not used
   CC      arch/x86/kernel/cpu/mtrr/cleanup.o
arch/x86/kernel/cpu/mtrr/cleanup.c: In function 'range_to_mtrr_with_hole':
arch/x86/kernel/cpu/mtrr/cleanup.c:299:16: warning: variable 
'second_basek' set but not used
arch/x86/kernel/cpu/mtrr/cleanup.c: In function 'mtrr_cleanup':
arch/x86/kernel/cpu/mtrr/cleanup.c:680:33: warning: variable 'dummy' set 
but not used
arch/x86/kernel/cpu/mtrr/cleanup.c: In function 'mtrr_trim_uncached_memory':
arch/x86/kernel/cpu/mtrr/cleanup.c:873:53: warning: variable 'dummy' set 
but not used
   LD      arch/x86/kernel/cpu/mtrr/built-in.o
   CC      arch/x86/kernel/cpu/perfctr-watchdog.o
arch/x86/kernel/cpu/perfctr-watchdog.c: In function 'setup_p4_watchdog':
arch/x86/kernel/cpu/perfctr-watchdog.c:469:28: warning: variable 'dummy' 
set but not used
   LD      arch/x86/kernel/cpu/built-in.o
   CC      arch/x86/kernel/reboot.o

   LD      arch/x86/kvm/built-in.o
   CC [M]  arch/x86/kvm/vmx.o
arch/x86/kvm/vmx.c: In function 'vmx_vcpu_setup':
arch/x86/kvm/vmx.c:2450:6: warning: variable 'junk' set but not used
   LD [M]  arch/x86/kvm/kvm-intel.o
   CC      arch/x86/mm/init.o


   CC      kernel/sched.o
kernel/sched.c: In function 'sched_init':
kernel/sched.c:7485:32: warning: variable 'ptr' set but not used
   CC      kernel/fork.o


   CC      kernel/async.o
kernel/async.c: In function 'async_synchronize_cookie_domain':
kernel/async.c:283:10: warning: 'starttime.tv64' may be used 
uninitialized in this function
   CC      kernel/range.o

   CC      kernel/irq/manage.o
kernel/irq/manage.c: In function '__setup_irq':
kernel/irq/manage.c:649:14: warning: variable 'old_name' set but not used
   CC      kernel/irq/spurious.o

   CC      kernel/module.o
kernel/module.c: In function 'add_usage_links':
kernel/module.c:1343:6: warning: variable 'nowarn' set but not used
   CC      kernel/kallsyms.o

   CC      kernel/audit.o
kernel/audit.c: In function 'audit_buffer_alloc':
kernel/audit.c:1044:19: warning: variable 'nlh' set but not used
   CC      kernel/auditfilter.o

   CC      fs/readdir.o
fs/readdir.c: In function 'filldir':
fs/readdir.c:155:15: warning: 'dirent' is used uninitialized in this 
function
fs/readdir.c: In function 'filldir64':
fs/readdir.c:240:15: warning: 'dirent' is used uninitialized in this 
function
   CC      fs/select.o

   CC [M]  fs/afs/fsclient.o
fs/afs/fsclient.c: In function 'afs_deliver_fs_xxxx_lock':
fs/afs/fsclient.c:1759:16: warning: variable 'bp' set but not used
   CC [M]  fs/afs/inode.o

   CC [M]  fs/cifs/cifssmb.o
fs/cifs/cifssmb.c: In function 'CIFSSMBSetFileSize':
fs/cifs/cifssmb.c:4855:8: warning: variable 'data_offset' set but not used
   CC [M]  fs/cifs/cifs_debug.o

   CC [M]  fs/cifs/dir.o
fs/cifs/dir.c: In function 'cifs_lookup':
fs/cifs/dir.c:641:15: warning: variable 'filp' set but not used
   CC [M]  fs/cifs/file.o
fs/cifs/file.c: In function 'cifs_partialpagewrite':
fs/cifs/file.c:1315:23: warning: variable 'pTcon' set but not used
   CC [M]  fs/cifs/inode.o

  CC [M]  fs/coda/upcall.o
fs/coda/upcall.c: In function 'venus_setattr':
fs/coda/upcall.c:115:27: warning: variable 'outp' set but not used
fs/coda/upcall.c: In function 'venus_close':
fs/coda/upcall.c:164:20: warning: variable 'outp' set but not used
fs/coda/upcall.c: In function 'venus_rename':
fs/coda/upcall.c:238:27: warning: variable 'outp' set but not used
fs/coda/upcall.c: In function 'venus_rmdir':
fs/coda/upcall.c:306:27: warning: variable 'outp' set but not used
fs/coda/upcall.c: In function 'venus_remove':
fs/coda/upcall.c:329:27: warning: variable 'outp' set but not used
fs/coda/upcall.c: In function 'venus_link':
fs/coda/upcall.c:383:27: warning: variable 'outp' set but not used
fs/coda/upcall.c: In function 'venus_symlink':
fs/coda/upcall.c:410:27: warning: variable 'outp' set but not used
fs/coda/upcall.c: In function 'venus_fsync':
fs/coda/upcall.c:443:27: warning: variable 'outp' set but not used
fs/coda/upcall.c: In function 'venus_access':
fs/coda/upcall.c:460:27: warning: variable 'outp' set but not used
   CC [M]  fs/coda/coda_linux.o

   CC      fs/ext4/mballoc.o
fs/ext4/mballoc.c: In function 'ext4_mb_normalize_request':
fs/ext4/mballoc.c:2846:15: warning: variable 'start_off' set but not used
fs/ext4/mballoc.c:2924:16: warning: 'start' may be used uninitialized in 
this function
   CC      fs/ext4/block_validity.o

   CC [M]  fs/hfs/bnode.o
fs/hfs/bnode.c: In function 'hfs_bnode_copy':
fs/hfs/bnode.c:100:20: warning: variable 'tree' set but not used
fs/hfs/bnode.c: In function '__hfs_bnode_create':
fs/hfs/bnode.c:238:22: warning: variable 'sb' set but not used
   CC [M]  fs/hfs/brec.o

   CC [M]  fs/hfsplus/extents.o
fs/hfsplus/extents.c: In function 'hfsplus_get_block':
fs/hfsplus/extents.c:178:6: warning: variable 'shift' set but not used
   CC [M]  fs/hfsplus/catalog.o

   CC [M]  fs/hfsplus/bnode.o
fs/hfsplus/bnode.c: In function 'hfsplus_bnode_copy':
fs/hfsplus/bnode.c:128:20: warning: variable 'tree' set but not used
fs/hfsplus/bnode.c: In function '__hfs_bnode_create':
fs/hfsplus/bnode.c:397:22: warning: variable 'sb' set but not used
   CC [M]  fs/hfsplus/brec.o

   CC [M]  fs/ntfs/file.o
fs/ntfs/file.c: In function 'ntfs_fault_in_pages_readable':
fs/ntfs/file.c:358:16: warning: variable 'c' set but not used
   CC [M]  fs/ntfs/index.o

   CC [M]  fs/ntfs/inode.o
fs/ntfs/inode.c: In function 'ntfs_truncate':
fs/ntfs/inode.c:2369:6: warning: variable 'attr_len' set but not used
   CC [M]  fs/ntfs/mft.o

   CC [M]  fs/ntfs/super.o
fs/ntfs/super.c: In function 'parse_ntfs_boot_sector':
fs/ntfs/super.c:753:41: warning: variable 'nr_hidden_sects' set but not used
fs/ntfs/super.c: In function 'check_windows_hibernation_status':
fs/ntfs/super.c:1254:14: warning: variable 'ni' set but not used
   CC [M]  fs/ntfs/sysctl.o
   CC [M]  fs/ntfs/logfile.o
fs/ntfs/logfile.c: In function 'ntfs_check_logfile':
fs/ntfs/logfile.c:494:21: warning: variable 'log_page_mask' set but not used
   CC [M]  fs/ntfs/quota.o

   CC [M]  fs/reiserfs/do_balan.o
fs/reiserfs/do_balan.c: In function 'balance_leaf':
fs/reiserfs/do_balan.c:331:10: warning: variable 'version' set but not used
fs/reiserfs/do_balan.c:754:10: warning: variable 'version' set but not used
fs/reiserfs/do_balan.c:1183:10: warning: variable 'version' set but not used
fs/reiserfs/do_balan.c:1425:10: warning: variable 'leaf_mi' set but not used
   CC [M]  fs/reiserfs/namei.o

   CC [M]  fs/reiserfs/file.o
fs/reiserfs/file.c: In function 'reiserfs_file_write':
fs/reiserfs/file.c:262:37: warning: variable 'th' set but not used
   CC [M]  fs/reiserfs/dir.o
   CC [M]  fs/reiserfs/fix_node.o
fs/reiserfs/fix_node.c: In function 'get_num_ver':
fs/reiserfs/fix_node.c:371:6: warning: variable 'cur_free' set but not used
fs/reiserfs/fix_node.c: In function 'dc_check_balance_internal':
fs/reiserfs/fix_node.c:1569:6: warning: variable 'maxsize' set but not used
fs/reiserfs/fix_node.c: In function 'dc_check_balance_leaf':
fs/reiserfs/fix_node.c:1752:6: warning: variable 'maxsize' set but not used
fs/reiserfs/fix_node.c:1750:6: warning: variable 'levbytes' set but not used
   CC [M]  fs/reiserfs/super.o
   CC [M]  fs/reiserfs/prints.o
fs/reiserfs/prints.c: In function 'check_internal_block_head':
fs/reiserfs/prints.c:722:21: warning: variable 'blkh' set but not used
   CC [M]  fs/reiserfs/objectid.o
fs/reiserfs/objectid.c: In function 'reiserfs_convert_objectid_map_v1':
fs/reiserfs/objectid.c:173:25: warning: variable 'new_objectid_map' set 
but not used
   CC [M]  fs/reiserfs/lbalance.o
fs/reiserfs/lbalance.c: In function 'leaf_copy_items':
fs/reiserfs/lbalance.c:478:22: warning: variable 'dest' set but not used
fs/reiserfs/lbalance.c: In function 'leaf_paste_entries':
fs/reiserfs/lbalance.c:1210:9: warning: variable 'old_entry_num' set but 
not used
   CC [M]  fs/reiserfs/ibalance.o
   CC [M]  fs/reiserfs/stree.o
fs/reiserfs/stree.c: In function 'search_by_key':
fs/reiserfs/stree.c:602:6: warning: variable 
'right_neighbor_of_leaf_node' set but not used
   CC [M]  fs/reiserfs/hashes.o
   CC [M]  fs/reiserfs/tail_conversion.o
   CC [M]  fs/reiserfs/journal.o
fs/reiserfs/journal.c: In function 'flush_older_commits':
fs/reiserfs/journal.c:927:15: warning: variable 'first_trans_id' set but 
not used
fs/reiserfs/journal.c: In function 'flush_journal_list':
fs/reiserfs/journal.c:1414:38: warning: variable 'last' set but not used
fs/reiserfs/journal.c: In function 'flush_used_journal_lists':
fs/reiserfs/journal.c:1855:6: warning: variable 'ret' set but not used
fs/reiserfs/journal.c: In function 'do_journal_release':
fs/reiserfs/journal.c:1963:6: warning: variable 'flushed' set but not used
fs/reiserfs/journal.c: In function 'do_journal_end':
fs/reiserfs/journal.c:4022:6: warning: variable 'old_start' set but not used
   CC [M]  fs/reiserfs/resize.o
   CC [M]  fs/reiserfs/item_ops.o

   CC      fs/udf/balloc.o
fs/udf/balloc.c: In function 'udf_bitmap_prealloc_blocks':
fs/udf/balloc.c:184:6: warning: variable 'nr_groups' set but not used
fs/udf/balloc.c:183:31: warning: variable 'group_start' set but not used
fs/udf/balloc.c: In function 'udf_table_free_blocks':
fs/udf/balloc.c:366:6: warning: variable 'i' set but not used
   CC      fs/udf/dir.o
   CC      fs/udf/file.o
   CC      fs/udf/ialloc.o
   CC      fs/udf/inode.o
fs/udf/inode.c: In function 'inode_getblk':
fs/udf/inode.c:472:18: warning: variable 'last_block' set but not used
fs/udf/inode.c: In function 'udf_fill_inode':
fs/udf/inode.c:1147:6: warning: variable 'offset' set but not used
   CC      fs/udf/lowlevel.o
   CC      fs/udf/namei.o
   CC      fs/udf/partition.o
   CC      fs/udf/super.o
fs/udf/super.c: In function 'udf_load_sequence':
fs/udf/super.c:1582:22: warning: variable 'sbi' set but not used
   CC      fs/udf/truncate.o


   CC      fs/binfmt_elf.o
fs/binfmt_elf.c: In function 'load_elf_binary':
fs/binfmt_elf.c:578:16: warning: variable 'reloc_func_desc' set but not used
   CC      fs/mbcache.o

   CC      security/keys/keyctl.o
security/keys/keyctl.c: In function 'keyctl_describe_key':
security/keys/keyctl.c:472:14: warning: variable 'key' set but not used
   CC      security/keys/permission.o
   CC      security/keys/process_keys.o
   CC      security/keys/request_key.o
security/keys/request_key.c: In function 'call_sbin_request_key':
security/keys/request_key.c:102:15: warning: variable 'prkey' set but 
not used
   CC      security/keys/request_key_auth.o
   CC      security/keys/user_defined.o
   CC      security/keys/proc.o

   CC      security/selinux/ss/ebitmap.o
security/selinux/ss/ebitmap.c: In function 'ebitmap_netlbl_import':
security/selinux/ss/ebitmap.c:159:27: warning: variable 'e_sft' set but 
not used
   CC      security/selinux/ss/hashtab.o

   CC      drivers/acpi/glue.o
drivers/acpi/glue.c: In function 'acpi_bind_one':
drivers/acpi/glue.c:163:7: warning: variable 'ret' set but not used
   CC      drivers/acpi/scan.o

   CC      drivers/ata/ahci.o
drivers/ata/ahci.c: In function 'ahci_init_one':
drivers/ata/ahci.c:1045:2: warning: comparison between 'enum 
<anonymous>' and 'enum <anonymous>'
   CC      drivers/ata/libahci.o

   CC      drivers/base/power/main.o
drivers/base/power/main.c: In function 'pm_noirq_op':
drivers/base/power/main.c:300:10: warning: 'calltime.tv64' may be used 
uninitialized in this function
   CC      drivers/base/power/generic_ops.o

   CC      drivers/base/module.o
drivers/base/module.c: In function 'module_add_driver':
drivers/base/module.c:36:6: warning: variable 'no_warn' set but not used
   LD      drivers/base/built-in.o
   CC      drivers/block/loop.o
   LD      drivers/block/built-in.o
   CC [M]  drivers/block/brd.o
   CC [M]  drivers/block/cryptoloop.o
drivers/block/cryptoloop.c: In function 'cryptoloop_init':
drivers/block/cryptoloop.c:46:8: warning: variable 'cipher' set but not used
   LD      drivers/bluetooth/built-in.o
   CC [M]  drivers/bluetooth/hci_vhci.o
   CC [M]  drivers/bluetooth/btmrvl_main.o
   CC [M]  drivers/bluetooth/btmrvl_debugfs.o
drivers/bluetooth/btmrvl_debugfs.c: In function 'btmrvl_hscfgcmd_write':
drivers/bluetooth/btmrvl_debugfs.c:59:15: warning: variable 'ret' set 
but not used
drivers/bluetooth/btmrvl_debugfs.c: In function 'btmrvl_psmode_write':
drivers/bluetooth/btmrvl_debugfs.c:102:15: warning: variable 'ret' set 
but not used
drivers/bluetooth/btmrvl_debugfs.c: In function 'btmrvl_pscmd_write':
drivers/bluetooth/btmrvl_debugfs.c:140:15: warning: variable 'ret' set 
but not used
drivers/bluetooth/btmrvl_debugfs.c: In function 'btmrvl_gpiogap_write':
drivers/bluetooth/btmrvl_debugfs.c:183:15: warning: variable 'ret' set 
but not used
drivers/bluetooth/btmrvl_debugfs.c: In function 'btmrvl_hscmd_write':
drivers/bluetooth/btmrvl_debugfs.c:221:15: warning: variable 'ret' set 
but not used
drivers/bluetooth/btmrvl_debugfs.c: In function 'btmrvl_hsmode_write':
drivers/bluetooth/btmrvl_debugfs.c:262:15: warning: variable 'ret' set 
but not used
   CC [M]  drivers/bluetooth/hci_ldisc.o
drivers/bluetooth/hci_ldisc.c: In function 'hci_uart_send_frame':
drivers/bluetooth/hci_ldisc.c:213:21: warning: variable 'tty' set but 
not used
   CC [M]  drivers/bluetooth/hci_h4.o
   CC [M]  drivers/bluetooth/hci_bcsp.o
drivers/bluetooth/hci_bcsp.c: In function 'bcsp_prepare_pkt':
drivers/bluetooth/hci_bcsp.c:247:20: warning: operation on 
'bcsp->msgq_txseq' may be undefined
   CC [M]  drivers/bluetooth/hci_ll.o

   CC      drivers/char/vt.o
drivers/char/vt.c: In function 'vc_do_resize':
drivers/char/vt.c:834:49: warning: variable 'old_screen_size' set but 
not used
drivers/char/vt.c:834:15: warning: variable 'old_cols' set but not used
   SHIPPED drivers/char/defkeymap.c
   CC      drivers/char/defkeymap.o
   CC      drivers/char/tty_audit.o
   CC      drivers/char/sysrq.o
   CC      drivers/char/raw.o
   CC      drivers/char/hpet.o
drivers/char/hpet.c: In function 'hpet_ioctl_common':
drivers/char/hpet.c:559:23: warning: variable 'hpet' set but not used
   CC      drivers/char/agp/backend.o
   CC      drivers/char/agp/frontend.o
drivers/char/agp/frontend.c: In function 'agp_find_seg_in_client':
drivers/char/agp/frontend.c:107:6: warning: variable 'num_segments' set 
but not used
   CC      drivers/char/agp/generic.o
drivers/char/agp/generic.c: In function 'agp_generic_create_gatt_table':
drivers/char/agp/generic.c:900:6: warning: variable 'size' set but not used
   CC      drivers/char/agp/isoch.o
drivers/char/agp/isoch.c: In function 'agp_3_5_isochronous_node_enable':
drivers/char/agp/isoch.c:86:5: warning: variable 'mcapndx' set but not used
drivers/char/agp/isoch.c: In function 'agp_3_5_enable':
drivers/char/agp/isoch.c:320:13: warning: variable 'arqsz' set but not used
   LD      drivers/char/agp/agpgart.o

   CC [M]  drivers/char/ipmi/ipmi_si_intf.o
drivers/char/ipmi/ipmi_si_intf.c: In function 'try_init_spmi':
drivers/char/ipmi/ipmi_si_intf.c:2010:8: warning: variable 'addr_space' 
set but not used
   CC [M]  drivers/char/ipmi/ipmi_kcs_sm.o
   CC [M]  drivers/char/ipmi/ipmi_smic_sm.o
   CC [M]  drivers/char/ipmi/ipmi_bt_sm.o
   LD [M]  drivers/char/ipmi/ipmi_si.o
   CC [M]  drivers/char/ipmi/ipmi_watchdog.o
   CC [M]  drivers/char/ipmi/ipmi_poweroff.o
   CC      drivers/char/tpm/tpm.o
drivers/char/tpm/tpm.c: In function 'tpm_gen_interrupt':
drivers/char/tpm/tpm.c:508:10: warning: variable 'rc' set but not used
   CC      drivers/char/tpm/tpm_bios.o

   CC [M]  drivers/crypto/hifn_795x.o
drivers/crypto/hifn_795x.c: In function 'hifn_flush':
drivers/crypto/hifn_795x.c:2021:23: warning: variable 'ctx' set but not used
drivers/crypto/hifn_795x.c: In function 'hifn_process_queue':
drivers/crypto/hifn_795x.c:2142:23: warning: variable 'ctx' set but not used
   CC      drivers/edac/edac_stub.o

   CC [M]  drivers/edac/i5000_edac.o
drivers/edac/i5000_edac.c: In function 'i5000_get_mc_regs':
drivers/edac/i5000_edac.c:1126:12: warning: variable 'way1' set but not used
drivers/edac/i5000_edac.c:1126:6: warning: variable 'way0' set but not used
drivers/edac/i5000_edac.c:1125:6: warning: variable 'maxdimmperch' set 
but not used
drivers/edac/i5000_edac.c:1124:6: warning: variable 'maxch' set but not used
drivers/edac/i5000_edac.c:1122:6: warning: variable 'limit' set but not used
drivers/edac/i5000_edac.c:1121:6: warning: variable 'actual_tolm' set 
but not used
drivers/edac/i5000_edac.c: In function 'i5000_init_csrows':
drivers/edac/i5000_edac.c:1239:13: warning: variable 'channel_count' set 
but not used
   CC [M]  drivers/edac/e752x_edac.o

   CC [M]  drivers/firewire/core-transaction.o
drivers/firewire/core-transaction.c: In function 'fw_core_handle_response':
drivers/firewire/core-transaction.c:835:21: warning: variable 
'destination' set but not used
   CC [M]  drivers/firewire/ohci.o

   CC [M]  drivers/gpu/drm/drm_gem.o
drivers/gpu/drm/drm_gem.c: In function 'drm_gem_handle_delete':
drivers/gpu/drm/drm_gem.c:188:21: warning: variable 'dev' set but not used
   CC [M]  drivers/gpu/drm/drm_ioctl.o

   CC [M]  drivers/gpu/drm/drm_modes.o
drivers/gpu/drm/drm_modes.c: In function 'drm_cvt_mode':
drivers/gpu/drm/drm_modes.c:176:27: warning: variable 'vback_porch' set 
but not used
drivers/gpu/drm/drm_modes.c: In function 'drm_gtf_mode_complex':
drivers/gpu/drm/drm_modes.c:323:28: warning: variable 'vframe_rate' set 
but not used
drivers/gpu/drm/drm_modes.c:322:45: warning: variable 'hperiod' set but 
not used
drivers/gpu/drm/drm_modes.c:322:29: warning: variable 'vfieldrate_est' 
set but not used
drivers/gpu/drm/drm_modes.c:321:21: warning: variable 'vback_porch' set 
but not used
   CC [M]  drivers/gpu/drm/drm_edid.o

   CC      drivers/i2c/i2c-core.o
drivers/i2c/i2c-core.c: In function 'i2c_register_adapter':
drivers/i2c/i2c-core.c:757:15: warning: variable 'dummy' set but not used
   LD      drivers/i2c/algos/built-in.o

   CC [M]  drivers/ieee1394/highlevel.o
drivers/ieee1394/highlevel.c: In function 
'hpsb_allocate_and_register_addrspace':
drivers/ieee1394/highlevel.c:368:13: warning: variable 'a2ea' set but 
not used
drivers/ieee1394/highlevel.c:367:7: warning: variable 'a1sa' set but not 
used
   CC [M]  drivers/ieee1394/csr.o

   CC [M]  drivers/ieee1394/raw1394.o
drivers/ieee1394/raw1394.c: In function 'arm_write':
drivers/ieee1394/raw1394.c:1018:39: warning: variable 'length_conflict' 
set but not used
drivers/ieee1394/raw1394.c: In function 'arm_lock64':
drivers/ieee1394/raw1394.c:1373:11: warning: 'old' may be used 
uninitialized in this function
drivers/ieee1394/raw1394.c: In function 'arm_lock':
drivers/ieee1394/raw1394.c:1155:12: warning: 'old' may be used 
uninitialized in this function
   CC [M]  drivers/ieee1394/sbp2.o
drivers/ieee1394/sbp2.c: In function 'sbp2_parse_unit_directory':
drivers/ieee1394/sbp2.c:1353:6: warning: variable 'unit_characteristics' 
set but not used
   CC [M]  drivers/ieee1394/dv1394.o
drivers/ieee1394/dv1394.c: In function 'frame_prepare':
drivers/ieee1394/dv1394.c:613:15: warning: variable 'ts_off' set but not 
used
drivers/ieee1394/dv1394.c: In function 'ir_tasklet_func':
drivers/ieee1394/dv1394.c:2007:22: warning: variable 'packet_time' set 
but not used
drivers/ieee1394/dv1394.c: In function 'dv1394_host_reset':
drivers/ieee1394/dv1394.c:2323:18: warning: variable 'ohci' set but not used
   CC [M]  drivers/ieee1394/eth1394.o
drivers/ieee1394/eth1394.c: In function 'ether1394_iso':
drivers/ieee1394/eth1394.c:1261:23: warning: variable 'priv' set but not 
used
   LD      drivers/ieee802154/built-in.o
   CC      drivers/input/input.o

   CC      drivers/md/dm.o
drivers/md/dm.c: In function 'split_bvec':
drivers/md/dm.c:1117:3: warning: statement with no effect
drivers/md/dm.c: In function 'clone_bio':
drivers/md/dm.c:1145:3: warning: statement with no effect
   CC      drivers/md/dm-table.o
drivers/md/dm-table.c: In function 'dm_table_set_integrity':
drivers/md/dm-table.c:1065:2: warning: statement with no effect
drivers/md/dm-table.c:1071:2: warning: statement with no effect
   CC      drivers/md/dm-target.o

   CC [M]  drivers/media/common/tuners/tuner-simple.o
drivers/media/common/tuners/tuner-simple.c: In function 
'simple_set_tv_freq':
drivers/media/common/tuners/tuner-simple.c:548:20: warning: variable 
'tun' set but not used
   CC [M]  drivers/media/common/tuners/tuner-types.o
   CC [M]  drivers/media/common/tuners/mt20xx.o
drivers/media/common/tuners/mt20xx.c: In function 'mt2050_set_antenna':
drivers/media/common/tuners/mt20xx.c:433:6: warning: variable 'ret' set 
but not used
drivers/media/common/tuners/mt20xx.c: In function 'mt2050_init':
drivers/media/common/tuners/mt20xx.c:577:6: warning: variable 'ret' set 
but not used
   CC [M]  drivers/media/common/tuners/tda8290.o

   CC [M]  drivers/media/video/gspca/gspca.o
drivers/media/video/gspca/gspca.c: In function 'vidioc_reqbufs':
drivers/media/video/gspca/gspca.c:1508:2: warning: case value '7' not in 
enumerated type 'enum v4l2_memory'
   LD [M]  drivers/media/video/gspca/gspca_main.o
   LD      drivers/media/video/uvc/built-in.o

   CC [M]  drivers/net/bonding/bond_main.o
drivers/net/bonding/bond_main.c: In function 'bond_send_gratuitous_arp':
drivers/net/bonding/bond_main.c:2603:21: warning: variable 'vlan_dev' 
set but not used
   CC [M]  drivers/net/bonding/bond_3ad.o
   CC [M]  drivers/net/bonding/bond_alb.o
   CC [M]  drivers/net/bonding/bond_sysfs.o
drivers/net/bonding/bond_sysfs.c: In function 'bonding_store_slaves':
drivers/net/bonding/bond_sysfs.c:222:14: warning: variable 'found' set 
but not used
drivers/net/bonding/bond_sysfs.c: In function 'bonding_store_carrier':
drivers/net/bonding/bond_sysfs.c:1226:17: warning: variable 'ret' set 
but not used
   LD [M]  drivers/net/bonding/bonding.o
   LD      drivers/net/wireless/built-in.o
   LD      drivers/net/wireless/hostap/built-in.o
   CC [M]  drivers/net/wireless/hostap/hostap_80211_rx.o
   CC [M]  drivers/net/wireless/hostap/hostap_80211_tx.o
   CC [M]  drivers/net/wireless/hostap/hostap_ap.o
drivers/net/wireless/hostap/hostap_ap.c: In function 
'hostap_ap_tx_cb_assoc':
drivers/net/wireless/hostap/hostap_ap.c:691:6: warning: variable 'fc' 
set but not used
drivers/net/wireless/hostap/hostap_ap.c: In function 'handle_assoc':
drivers/net/wireless/hostap/hostap_ap.c:1502:8: warning: variable 'txt' 
set but not used
   CC [M]  drivers/net/wireless/hostap/hostap_info.o
   CC [M]  drivers/net/wireless/hostap/hostap_ioctl.o
drivers/net/wireless/hostap/hostap_ioctl.c: In function 
'prism2_request_scan':
drivers/net/wireless/hostap/hostap_ioctl.c:1666:6: warning: variable 
'ret' set but not used
drivers/net/wireless/hostap/hostap_ioctl.c: In function 
'prism2_translate_scan':
drivers/net/wireless/hostap/hostap_ioctl.c:1955:13: warning: variable 
'hostscan' set but not used
   CC [M]  drivers/net/wireless/hostap/hostap_main.o
drivers/net/wireless/hostap/hostap_main.c: In function 
'hostap_set_multicast_list_queue':
drivers/net/wireless/hostap/hostap_main.c:744:27: warning: variable 
'iface' set but not used
   CC [M]  drivers/net/wireless/hostap/hostap_proc.o
   LD [M]  drivers/net/wireless/hostap/hostap.o
   CC [M]  drivers/net/wireless/hostap/hostap_plx.o
In file included from drivers/net/wireless/hostap/hostap_plx.c:264:0:
drivers/net/wireless/hostap/hostap_hw.c: In function 'prism2_tx_80211':
drivers/net/wireless/hostap/hostap_hw.c:1816:18: warning: variable 'fc' 
set but not used
   CC [M]  drivers/net/wireless/hostap/hostap_pci.o
In file included from drivers/net/wireless/hostap/hostap_pci.c:221:0:
drivers/net/wireless/hostap/hostap_hw.c: In function 'prism2_tx_80211':
drivers/net/wireless/hostap/hostap_hw.c:1816:18: warning: variable 'fc' 
set but not used
   LD      drivers/net/built-in.o
   CC [M]  drivers/net/forcedeth.o
drivers/net/forcedeth.c: In function 'nv_open':
drivers/net/forcedeth.c:5297:7: warning: variable 'miistat' set but not used
   CC [M]  drivers/net/ppp_generic.o

   CC      drivers/pci/bus.o
drivers/pci/bus.c: In function 'pci_enable_bridges':
drivers/pci/bus.c:237:6: warning: variable 'retval' set but not used
   CC      drivers/pci/probe.o

   CC      drivers/pci/setup-bus.o
drivers/pci/setup-bus.c: In function 
'pci_assign_unassigned_bridge_resources':
drivers/pci/setup-bus.c:868:6: warning: variable 'retval' set but not used
   CC      drivers/pci/pci-acpi.o

   CC      drivers/scsi/hosts.o
drivers/scsi/hosts.c: In function 'scsi_host_alloc':
drivers/scsi/hosts.c:328:6: warning: variable 'rval' set but not used
   CC      drivers/scsi/scsi_ioctl.o

   CC      drivers/scsi/sg.o
drivers/scsi/sg.c: In function 'sg_common_write':
drivers/scsi/sg.c:710:9: warning: variable 'data_dir' set but not used
   LD      drivers/scsi/built-in.o

   CC      drivers/usb/core/sysfs.o
drivers/usb/core/sysfs.c: In function 'usb_create_sysfs_intf_files':
drivers/usb/core/sysfs.c:889:6: warning: variable 'retval' set but not used
   CC      drivers/usb/core/endpoint.o

   CC [M]  drivers/usb/host/ehci-hcd.o
In file included from drivers/usb/host/ehci-hcd.c:306:0:
drivers/usb/host/ehci-hub.c: In function 'create_companion_file':
drivers/usb/host/ehci-hub.c:533:6: warning: variable 'i' set but not used
In file included from drivers/usb/host/ehci-hcd.c:308:0:
drivers/usb/host/ehci-q.c: In function 'submit_async':
drivers/usb/host/ehci-q.c:1110:20: warning: variable 'qtd' set but not used
In file included from drivers/usb/host/ehci-hcd.c:309:0:
drivers/usb/host/ehci-sched.c: In function 'itd_complete':
drivers/usb/host/ehci-sched.c:1686:23: warning: variable 'dev' set but 
not used
drivers/usb/host/ehci-sched.c: In function 'sitd_complete':
drivers/usb/host/ehci-sched.c:2091:23: warning: variable 'dev' set but 
not used
   CC [M]  drivers/usb/host/ohci-hcd.o
   CC [M]  drivers/usb/host/uhci-hcd.o
   CC [M]  drivers/usb/host/xhci.o
drivers/usb/host/xhci.c: In function 'xhci_add_endpoint':
drivers/usb/host/xhci.c:1013:22: warning: variable 'ep_ctx' set but not used
   CC [M]  drivers/usb/host/xhci-mem.o
   CC [M]  drivers/usb/host/xhci-pci.o
   CC [M]  drivers/usb/host/xhci-ring.o
drivers/usb/host/xhci-ring.c: In function 'next_trb':
drivers/usb/host/xhci-ring.c:134:8: warning: operation on '*trb' may be 
undefined
drivers/usb/host/xhci-ring.c: In function 'handle_cmd_completion':
drivers/usb/host/xhci-ring.c:967:20: warning: variable 'ep_ring' set but 
not used
   CC [M]  drivers/usb/host/xhci-hub.o
   CC [M]  drivers/usb/host/xhci-dbg.o
drivers/usb/host/xhci-dbg.c: In function 'xhci_dbg_ctx':
drivers/usb/host/xhci-dbg.c:545:24: warning: variable 'slot_ctx' set but 
not used
   LD [M]  drivers/usb/host/xhci-hcd.o
   CC      drivers/usb/misc/usblcd.o
   CC      drivers/usb/misc/usbled.o
   LD      drivers/usb/misc/built-in.o
   CC [M]  drivers/usb/misc/isight_firmware.o
   LD      drivers/usb/storage/built-in.o
   CC [M]  drivers/usb/storage/scsiglue.o
   CC [M]  drivers/usb/storage/protocol.o
   CC [M]  drivers/usb/storage/transport.o
   CC [M]  drivers/usb/storage/usb.o
   CC [M]  drivers/usb/storage/initializers.o
drivers/usb/storage/initializers.c: In function 'usb_stor_euscsi_init':
drivers/usb/storage/initializers.c:49:6: warning: variable 'result' set 
but not used
drivers/usb/storage/initializers.c: In function 'usb_stor_huawei_e220_init':
drivers/usb/storage/initializers.c:98:6: warning: variable 'result' set 
but not used
   CC [M]  drivers/usb/storage/sierra_ms.o
drivers/usb/storage/sierra_ms.c: In function 'sierra_ms_init':
drivers/usb/storage/sierra_ms.c:133:22: warning: variable 'sd' set but 
not used
drivers/usb/storage/sierra_ms.c:129:14: warning: variable 'delay_t' set 
but not used
   CC [M]  drivers/usb/storage/option_ms.o
   CC [M]  drivers/usb/storage/usual-tables.o

   CC      drivers/video/console/fbcon.o
drivers/video/console/fbcon.c: In function 'fb_flashcursor':
drivers/video/console/fbcon.c:372:18: warning: variable 'p' set but not used
drivers/video/console/fbcon.c: In function 'fbcon_exit':
drivers/video/console/fbcon.c:3483:7: warning: variable 'pending' set 
but not used
   CC      drivers/video/console/bitblit.o

   CC      drivers/video/console/fbcon_cw.o
drivers/video/console/fbcon_cw.c: In function 'cw_update_attr':
drivers/video/console/fbcon_cw.c:30:8: warning: variable 't' set but not 
used
   CC      drivers/video/console/fbcon_ud.o

   CC      sound/core/init.o
sound/core/init.c: In function 'snd_card_disconnect':
sound/core/init.c:345:15: warning: variable 'file' set but not used
   CC      sound/core/memory.o
   CC      sound/core/info.o
   CC      sound/core/control.o
sound/core/control.c: In function 'snd_ctl_elem_list':
sound/core/control.c:594:30: warning: variable 'first' set but not used
   CC      sound/core/misc.o
   CC      sound/core/device.o
   CC      sound/core/isadma.o
   CC      sound/core/vmaster.o
sound/core/vmaster.c: In function 'slave_update':
sound/core/vmaster.c:60:6: warning: variable 'err' set but not used
   LD      sound/core/snd.o
   LD      sound/core/built-in.o
   CC [M]  sound/core/hwdep.o
   CC [M]  sound/core/memalloc.o
   CC [M]  sound/core/sgbuf.o
   CC [M]  sound/core/pcm.o
   CC [M]  sound/core/pcm_native.o
sound/core/pcm_native.c: In function 'snd_pcm_drop':
sound/core/pcm_native.c:1516:19: warning: variable 'card' set but not used
sound/core/pcm_native.c: In function 'snd_pcm_open_file':
sound/core/pcm_native.c:2052:22: warning: variable 'str' set but not used
sound/core/pcm_native.c: In function 'snd_pcm_mmap_status':
sound/core/pcm_native.c:3011:26: warning: variable 'runtime' set but not 
used
sound/core/pcm_native.c: In function 'snd_pcm_mmap_control':
sound/core/pcm_native.c:3050:26: warning: variable 'runtime' set but not 
used
   CC [M]  sound/core/pcm_lib.o

   CC [M]  sound/pci/hda/patch_nvhdmi.o
sound/pci/hda/patch_nvhdmi.c: In function 
'nvhdmi_dig_playback_pcm_prepare_8ch':
sound/pci/hda/patch_nvhdmi.c:216:15: warning: variable 'dataDCC1' set 
but not used
   CC [M]  sound/pci/hda/patch_realtek.o

   CC [M]  net/bluetooth/sco.o
net/bluetooth/sco.c: In function 'sco_sock_getsockopt':
net/bluetooth/sco.c:724:6: warning: variable 'len' set but not used
   LD      net/bluetooth/bnep/built-in.o

   CC      net/core/dev_addr_lists.o
net/core/dev_addr_lists.c: In function '__hw_addr_del_multiple':
net/core/dev_addr_lists.c:143:16: warning: variable 'type' set but not used
   CC      net/core/dst.o

   CC      net/ipv4/ipconfig.o
net/ipv4/ipconfig.c: In function 'ic_rarp_recv':
net/ipv4/ipconfig.c:467:17: warning: variable 'sha' set but not used
   CC      net/ipv4/netfilter.o
   LD      net/ipv4/netfilter/built-in.o
   CC [M]  net/ipv4/netfilter/nf_nat_rule.o
   CC [M]  net/ipv4/netfilter/nf_nat_standalone.o
net/ipv4/netfilter/nf_nat_standalone.c: In function 'nf_nat_fn':
net/ipv4/netfilter/nf_nat_standalone.c:118:2: warning: case value '4' 
not in enumerated type 'enum ip_conntrack_info'
   CC [M]  net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.o

   CC [M]  net/ipv4/netfilter/nf_nat_proto_sctp.o
net/ipv4/netfilter/nf_nat_proto_sctp.c: In function 'sctp_manip_pkt':
net/ipv4/netfilter/nf_nat_proto_sctp.c:39:16: warning: variable 'newip' 
set but not used
net/ipv4/netfilter/nf_nat_proto_sctp.c:39:9: warning: variable 'oldip' 
set but not used
   CC [M]  net/ipv4/netfilter/ip_tables.o

   CC [M]  net/ipv4/netfilter/ipt_CLUSTERIP.o
net/ipv4/netfilter/ipt_CLUSTERIP.c: In function 'clusterip_tg':
net/ipv4/netfilter/ipt_CLUSTERIP.c:323:3: warning: case value '4' not in 
enumerated type 'enum ip_conntrack_info'
   CC [M]  net/ipv4/netfilter/ipt_ECN.o

   CC      net/mac80211/sta_info.o
net/mac80211/sta_info.c: In function 'sta_info_cleanup_expire_buffered':
net/mac80211/sta_info.c:583:32: warning: variable 'sdata' set but not used
   CC      net/mac80211/wep.o
   CC      net/mac80211/wpa.o
   CC      net/mac80211/scan.o
net/mac80211/scan.c: In function 'ieee80211_request_internal_scan':
net/mac80211/scan.c:749:23: warning: comparison between 'enum 
nl80211_band' and 'enum ieee80211_band'
   CC      net/mac80211/offchannel.o
   CC      net/mac80211/ht.o
   CC      net/mac80211/agg-tx.o
   CC      net/mac80211/agg-rx.o
   CC      net/mac80211/ibss.o
net/mac80211/ibss.c: In function 'ieee80211_rx_mgmt_auth_ibss':
net/mac80211/ibss.c:44:34: warning: variable 'status_code' set but not used
net/mac80211/ibss.c: In function 'ieee80211_sta_create_ibss':
net/mac80211/ibss.c:501:35: warning: variable 'sband' set but not used
   CC      net/mac80211/mlme.o
   CC      net/mac80211/work.o
net/mac80211/work.c: In function 'ieee80211_send_assoc':
net/mac80211/work.c:210:9: warning: variable 'len' set but not used
net/mac80211/work.c:208:12: warning: variable 'ies' set but not used
   CC      net/mac80211/iface.o
   CC      net/mac80211/rate.o
   CC      net/mac80211/michael.o
   CC      net/mac80211/tkip.o
   CC      net/mac80211/aes_ccm.o
net/mac80211/aes_ccm.c: In function 'ieee80211_aes_ccm_encrypt':
net/mac80211/aes_ccm.c:57:39: warning: variable 'aad' set but not used
net/mac80211/aes_ccm.c: In function 'ieee80211_aes_ccm_decrypt':
net/mac80211/aes_ccm.c:97:39: warning: variable 'aad' set but not used
   CC      net/mac80211/aes_cmac.o
   CC      net/mac80211/cfg.o
   CC      net/mac80211/rx.o
net/mac80211/rx.c: In function 'ieee80211_release_reorder_frame':
net/mac80211/rx.c:542:25: warning: variable 'rate' set but not used
net/mac80211/rx.c: In function 'ieee80211_reassemble_add':
net/mac80211/rx.c:1154:6: warning: variable 'idx' set but not used
   CC      net/mac80211/spectmgmt.o
   CC      net/mac80211/tx.o
net/mac80211/tx.c: In function '__ieee80211_parse_tx_radiotap':
net/mac80211/tx.c:1021:35: warning: variable 'sband' set but not used
net/mac80211/tx.c: In function 'ieee80211_get_buffered_bc':
net/mac80211/tx.c:2428:19: warning: variable 'sta' set but not used
   CC      net/mac80211/key.o

   CC      net/netfilter/ipvs/ip_vs_core.o
net/netfilter/ipvs/ip_vs_core.c: In function 'ip_vs_leave':
net/netfilter/ipvs/ip_vs_core.c:465:12: warning: variable 'cs' set but 
not used
net/netfilter/ipvs/ip_vs_core.c: In function 'ip_vs_in':
net/netfilter/ipvs/ip_vs_core.c:1290:11: warning: variable 'restart' set 
but not used
   CC      net/netfilter/ipvs/ip_vs_ctl.o

   CC [M]  net/netfilter/nfnetlink_log.o
net/netfilter/nfnetlink_log.c: In function '__build_packet_message':
net/netfilter/nfnetlink_log.c:375:9: warning: variable 'tmp_uint' set 
but not used
   CC [M]  net/netfilter/nf_conntrack_core.o
   CC [M]  net/netfilter/nf_conntrack_standalone.o
net/netfilter/nf_conntrack_standalone.c: In function 'ct_seq_show':
net/netfilter/nf_conntrack_standalone.c:118:6: warning: variable 'ret' 
set but not used
   CC [M]  net/netfilter/nf_conntrack_expect.o

   CC [M]  net/netfilter/nf_conntrack_netlink.o
net/netfilter/nf_conntrack_netlink.c: In function 'ctnetlink_parse_tuple':
net/netfilter/nf_conntrack_netlink.c:762:11: warning: comparison between 
'enum ctattr_tuple' and 'enum ctattr_type'
   CC [M]  net/netfilter/nf_conntrack_amanda.o

  CC [M]  net/netfilter/xt_rateest.o
net/netfilter/xt_rateest.c: In function 'xt_rateest_mt_checkentry':
net/netfilter/xt_rateest.c:81:6: warning: variable 'ret' set but not used
   CC [M]  net/netfilter/xt_realm.o

   CC      net/netlabel/netlabel_domainhash.o
net/netlabel/netlabel_domainhash.c: In function 'netlbl_domhsh_add':
net/netlabel/netlabel_domainhash.c:354:21: warning: variable 'old_list6' 
set but not used
   CC      net/netlabel/netlabel_addrlist.o
   CC      net/netlabel/netlabel_mgmt.o
   CC      net/netlabel/netlabel_unlabeled.o
net/netlabel/netlabel_unlabeled.c: In function 'netlbl_unlabel_staticlist':
net/netlabel/netlabel_unlabeled.c:1236:38: warning: variable 
'iter_addr6' set but not used
   CC      net/netlabel/netlabel_cipso_v4.o
net/netlabel/netlabel_cipso_v4.c: In function 'netlbl_cipsov4_add':
net/netlabel/netlabel_cipso_v4.c:425:14: warning: variable 'type_str' 
set but not used
   LD      net/netlabel/built-in.o
   CC      net/netlink/af_netlink.o
   CC      net/netlink/genetlink.o
   LD      net/netlink/built-in.o
   CC      net/packet/af_packet.o
net/packet/af_packet.c: In function 'tpacket_snd':
net/packet/af_packet.c:930:17: warning: variable 'sock' set but not used
   LD      net/packet/built-in.o
   LD      net/rxrpc/built-in.o
   CC [M]  net/rxrpc/af_rxrpc.o
   CC [M]  net/rxrpc/ar-accept.o
   CC [M]  net/rxrpc/ar-ack.o
net/rxrpc/ar-ack.c: In function 'rxrpc_rotate_tx_window':
net/rxrpc/ar-ack.c:375:25: warning: variable 'sp' set but not used
   CC [M]  net/rxrpc/ar-call.o
   CC [M]  net/rxrpc/ar-connection.o
   CC [M]  net/rxrpc/ar-connevent.o
net/rxrpc/ar-connevent.c: In function 'rxrpc_process_connection':
net/rxrpc/ar-connevent.c:262:25: warning: variable 'sp' set but not used
   CC [M]  net/rxrpc/ar-error.o
net/rxrpc/ar-error.c: In function 'rxrpc_UDP_error_handler':
net/rxrpc/ar-error.c:142:6: warning: variable 'local' set but not used
   CC [M]  net/rxrpc/ar-input.o
   CC [M]  net/rxrpc/ar-key.o
   CC [M]  net/rxrpc/ar-local.o
   CC [M]  net/rxrpc/ar-output.o
   CC [M]  net/rxrpc/ar-peer.o
net/rxrpc/ar-peer.c: In function 'rxrpc_get_peer':
net/rxrpc/ar-peer.c:125:6: warning: variable 'usage' set but not used
   CC [M]  net/rxrpc/ar-recvmsg.o

   CC [M]  net/rxrpc/ar-transport.o
net/rxrpc/ar-transport.c: In function 'rxrpc_get_transport':
net/rxrpc/ar-transport.c:80:6: warning: variable 'usage' set but not used
   CC [M]  net/rxrpc/ar-proc.o
   LD [M]  net/rxrpc/af-rxrpc.o
   CC [M]  net/rxrpc/rxkad.o
   CC      net/sched/sch_generic.o
   CC      net/sched/sch_mq.o
   LD      net/sched/built-in.o
   CC      net/unix/af_unix.o
net/unix/af_unix.c: In function 'unix_stream_sendmsg':
net/unix/af_unix.c:1503:22: warning: variable 'sunaddr' set but not used
   CC      net/unix/garbage.o
   CC      net/unix/sysctl_net_unix.o
   LD      net/unix/unix.o
   LD      net/unix/built-in.o
   CC      net/wireless/core.o
   CC      net/wireless/sysfs.o
   CC      net/wireless/radiotap.o
   CC      net/wireless/util.o
   CC      net/wireless/reg.o
net/wireless/reg.c: In function 'freq_reg_info_regd':
net/wireless/reg.c:1165:38: warning: variable 'pr' set but not used
net/wireless/reg.c: In function 'regulatory_hint_11d':
net/wireless/reg.c:2050:7: warning: variable 'alpha2' set but not used
   CC      net/wireless/scan.o

   CC [M]  net/wireless/lib80211_crypt_wep.o
net/wireless/lib80211_crypt_wep.c: In function 'lib80211_wep_build_iv':
net/wireless/lib80211_crypt_wep.c:99:12: warning: variable 'len' set but 
not used
   CC [M]  net/wireless/lib80211_crypt_ccmp.o

   CC      lib/decompress_unlzo.o
lib/decompress_unlzo.c: In function 'parse_header':
lib/decompress_unlzo.c:57:5: warning: variable 'level' set but not used
   CC      lib/dump_stack.o

   CC      lib/radix-tree.o
lib/radix-tree.c: In function 'radix_tree_tag_get':
lib/radix-tree.c:568:6: warning: variable 'saw_unset_tag' set but not used
   CC      lib/ratelimit.o
   CC      lib/rbtree.o
   CC      lib/reciprocal_div.o
   CC      lib/rwsem.o
   CC      lib/sha1.o
   CC      lib/show_mem.o
   CC      lib/string.o
   CC      lib/vsprintf.o
lib/vsprintf.c: In function 'vbin_printf':
lib/vsprintf.c:1655:10: warning: variable 'skip_arg' set but not used
   AR      lib/lib.a



still getting lots of spam,
but lots nicer after your series.

Justin P. Mattock
